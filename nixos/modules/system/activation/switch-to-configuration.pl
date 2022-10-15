#! @perl@/bin/perl

# Issue #166838 uncovered a situation in which a configuration not suitable
# for the target architecture caused a cryptic error message instead of
# a clean failure. Due to this mismatch, the perl interpreter in the shebang
# line wasn't able to be executed, causing this script to be misinterpreted
# as a shell script.
#
# Let's detect this situation to give a more meaningful error
# message. The following two lines are carefully written to be both valid Perl
# and Bash.
printf "Perl script erroneously interpreted as shell script,\ndoes target platform match nixpkgs.crossSystem platform?\n" && exit 1
    if 0;

use strict;
use warnings;
use Config::IniFiles;
use File::Path qw(make_path);
use File::Basename;
use File::Slurp qw(read_file write_file edit_file);
use JSON::PP;
use IPC::Cmd;
use Sys::Syslog qw(:standard :macros);
use Cwd qw(abs_path);

## no critic(ControlStructures::ProhibitDeepNests)
## no critic(ErrorHandling::RequireCarping)
## no critic(CodeLayout::ProhibitParensWithBuiltins)
## no critic(Variables::ProhibitPunctuationVars, Variables::RequireLocalizedPunctuationVars)
## no critic(InputOutput::RequireCheckedSyscalls, InputOutput::RequireBracedFileHandleWithPrint, InputOutput::RequireBriefOpen)
## no critic(ValuesAndExpressions::ProhibitNoisyQuotes, ValuesAndExpressions::ProhibitMagicNumbers, ValuesAndExpressions::ProhibitEmptyQuotes, ValuesAndExpressions::ProhibitInterpolationOfLiterals)
## no critic(RegularExpressions::ProhibitEscapedMetacharacters)

# System closure path to switch to
my $out = "@out@";
# Path to the directory containing systemd tools of the old system
my $cur_systemd = abs_path("/run/current-system/sw/bin");
# Path to the systemd store path of the new system
my $new_systemd = "@systemd@";

# To be robust against interruption, record what units need to be started etc.
# We read these files again every time this script starts to make sure we continue
# where the old (interrupted) script left off.
my $start_list_file = "/run/nixos/start-list";
my $restart_list_file = "/run/nixos/restart-list";
my $reload_list_file = "/run/nixos/reload-list";

# Parse restart/reload requests by the activation script.
# Activation scripts may write newline-separated units to the restart
# file and switch-to-configuration will handle them. While
# `stopIfChanged = true` is ignored, switch-to-configuration will
# handle `restartIfChanged = false` and `reloadIfChanged = true`.
# This is the same as specifying a restart trigger in the NixOS module.
#
# The reload file asks the script to reload a unit. This is the same as
# specifying a reload trigger in the NixOS module and can be ignored if
# the unit is restarted in this activation.
my $restart_by_activation_file = "/run/nixos/activation-restart-list";
my $reload_by_activation_file = "/run/nixos/activation-reload-list";
my $dry_restart_by_activation_file = "/run/nixos/dry-activation-restart-list";
my $dry_reload_by_activation_file = "/run/nixos/dry-activation-reload-list";

# The action that is to be performed (like switch, boot, test, dry-activate)
# Also exposed via environment variable from now on
my $action = shift(@ARGV);
$ENV{NIXOS_ACTION} = $action;

# Expose the locale archive as an environment variable for systemctl and the activation script
if ("@localeArchive@" ne "") {
    $ENV{LOCALE_ARCHIVE} = "@localeArchive@";
}

if (!defined($action) || ($action ne "switch" && $action ne "boot" && $action ne "test" && $action ne "dry-activate")) {
    print STDERR <<"EOF";
Usage: $0 [switch|boot|test]

switch:       make the configuration the boot default and activate now
boot:         make the configuration the boot default
test:         activate the configuration, but don\'t make it the boot default
dry-activate: show what would be done if this configuration were activated
EOF
    exit(1);
}

# This is a NixOS installation if it has /etc/NIXOS or a proper
# /etc/os-release.
if (!-f "/etc/NIXOS" && (read_file("/etc/os-release", err_mode => "quiet") // "") !~ /^ID="?nixos"?/msx) {
    die("This is not a NixOS installation!\n");
}

make_path("/run/nixos", { mode => oct(755) });
openlog("nixos", "", LOG_USER);

# Install or update the bootloader.
if ($action eq "switch" || $action eq "boot") {
    chomp(my $install_boot_loader = <<'EOFBOOTLOADER');
@installBootLoader@
EOFBOOTLOADER
    system("$install_boot_loader $out") == 0 or exit 1;
}

# Just in case the new configuration hangs the system, do a sync now.
if (($ENV{"NIXOS_NO_SYNC"} // "") ne "1") {
    system("@coreutils@/bin/sync", "-f", "/nix/store");
}

if ($action eq "boot") {
    exit(0);
}

# Check if we can activate the new configuration.
my $cur_init_interface_version = read_file("/run/current-system/init-interface-version", err_mode => "quiet") // "";
my $new_init_interface_version = read_file("$out/init-interface-version");

if ($new_init_interface_version ne $cur_init_interface_version) {
    print STDERR <<'EOF';
Warning: the new NixOS configuration has an ‘init’ that is
incompatible with the current configuration.  The new configuration
won't take effect until you reboot the system.
EOF
    exit(100);
}

# Ignore SIGHUP so that we're not killed if we're running on (say)
# virtual console 1 and we restart the "tty1" unit.
$SIG{PIPE} = "IGNORE";

# Replacement for Net::DBus that calls busctl of the current systemd, parses
# it's json output and returns the response using only core modules to reduce
# dependencies on perlPackages in baseSystem
sub busctl_call_systemd1_mgr {
    my (@args) = @_;
    my $cmd = [
        "$cur_systemd/busctl", "--json=short", "call", "org.freedesktop.systemd1",
        "/org/freedesktop/systemd1", "org.freedesktop.systemd1.Manager",
        @args
    ];

    my ($ok, $err, undef, $stdout) = IPC::Cmd::run(command => $cmd);
    die $err unless $ok;

    my $res = decode_json(join "", @$stdout);
    return $res;
}

# Asks the currently running systemd instance via dbus which units are active.
# Returns a hash where the key is the name of each unit and the value a hash
# of load, state, substate.
sub get_active_units {
    my $units = busctl_call_systemd1_mgr("ListUnitsByPatterns", "asas", 0, 0)->{data}->[0];
    my $res = {};
    for my $item (@{$units}) {
        my ($id, $description, $load_state, $active_state, $sub_state,
            $following, $unit_path, $job_id, $job_type, $job_path) = @{$item};
        if ($following ne "") {
            next;
        }
        if ($job_id == 0 and $active_state eq "inactive") {
            next;
        }
        $res->{$id} = { load => $load_state, state => $active_state, substate => $sub_state };
    }
    return $res;
}

# Asks the currently running systemd instance whether a unit is currently active.
# Takes the name of the unit as an argument and returns a bool whether the unit is active or not.
sub unit_is_active {
    my ($unit_name) = @_;
    my $units = busctl_call_systemd1_mgr("ListUnitsByNames", "as", 1, , "--", $unit_name)->{data}->[0];
    if (scalar(@{$units}) == 0) {
        return 0;
    }
    my $active_state = $units->[0]->[3];
    return $active_state eq "active" || $active_state eq "activating";
}

# Parse a fstab file, given its path.
# Returns a tuple of filesystems and swaps.
#
# Filesystems is a hash of mountpoint and { device, fsType, options }
# Swaps is a hash of device and { options }
sub parse_fstab {
    my ($filename) = @_;
    my ($fss, $swaps);
    foreach my $line (read_file($filename, err_mode => "quiet")) {
        chomp($line);
        $line =~ s/^\s*\#.*//msx;
        if ($line =~ /^\s*$/msx) {
            next;
        }
        my @xs = split(/\s+/msx, $line);
        if ($xs[2] eq "swap") {
            $swaps->{$xs[0]} = { options => $xs[3] // "" };
        } else {
            $fss->{$xs[1]} = { device => $xs[0], fsType => $xs[2], options => $xs[3] // "" };
        }
    }
    return ($fss, $swaps);
}

# This subroutine takes a single ini file that specified systemd configuration
# like unit configuration and parses it into a hash where the keys are the sections
# of the unit file and the values are hashes themselves. These hashes have the unit file
# keys as their keys (left side of =) and an array of all values that were set as their
# values. If a value is empty (for example `ExecStart=`), then all current definitions are
# removed.
#
# Instead of returning the hash, this subroutine takes a hashref to return the data in. This
# allows calling the subroutine multiple times with the same hash to parse override files.
sub parse_systemd_ini {
    my ($unit_contents, $path) = @_;
    # Tie the ini file to a hash for easier access
    tie(my %file_contents, "Config::IniFiles", (-file => $path, -allowempty => 1, -allowcontinue => 1)); ## no critic(Miscellanea::ProhibitTies)

    # Copy over all sections
    foreach my $section_name (keys(%file_contents)) {
        if ($section_name eq "Install") {
            # Skip the [Install] section because it has no relevant keys for us
            next;
        }
        # Copy over all keys
        foreach my $ini_key (keys(%{$file_contents{$section_name}})) {
            # Ensure the value is an array so it's easier to work with
            my $ini_value = $file_contents{$section_name}{$ini_key};
            my @ini_values;
            if (ref($ini_value) eq "ARRAY") {
                @ini_values = @{$ini_value};
            } else {
                @ini_values = $ini_value;
            }
            # Go over all values
            for my $ini_value (@ini_values) {
                # If a value is empty, it's an override that tells us to clean the value
                if ($ini_value eq "") {
                    delete $unit_contents->{$section_name}->{$ini_key};
                    next;
                }
                push(@{$unit_contents->{$section_name}->{$ini_key}}, $ini_value);
            }
        }
    }
    return;
}

# This subroutine takes the path to a systemd configuration file (like a unit configuration),
# parses it, and returns a hash that contains the contents. The contents of this hash are
# explained in the `parse_systemd_ini` subroutine. Neither the sections nor the keys inside
# the sections are consistently sorted.
#
# If a directory with the same basename ending in .d exists next to the unit file, it will be
# assumed to contain override files which will be parsed as well and handled properly.
sub parse_unit {
    my ($unit_path) = @_;

    # Parse the main unit and all overrides
    my %unit_data;
    # Replace \ with \\ so glob() still works with units that have a \ in them
    # Valid characters in unit names are ASCII letters, digits, ":", "-", "_", ".", and "\"
    $unit_path =~ s/\\/\\\\/gmsx;
    foreach (glob("${unit_path}{,.d/*.conf}")) {
        parse_systemd_ini(\%unit_data, "$_")
    }
    return %unit_data;
}

# Checks whether a specified boolean in a systemd unit is true
# or false, with a default that is applied when the value is not set.
sub parse_systemd_bool {
    my ($unit_config, $section_name, $bool_name, $default) = @_;

    my @values = @{$unit_config->{$section_name}{$bool_name} // []};
    # Return default if value is not set
    if ((scalar(@values) < 1) || (not defined($values[-1]))) {
        return $default;
    }
    # If value is defined multiple times, use the last definition
    my $last_value = $values[-1];
    # These are valid values as of systemd.syntax(7)
    return $last_value eq "1" || $last_value eq "yes" || $last_value eq "true" || $last_value eq "on";
}

# Writes a unit name into a given file to be more resilient against
# crashes of the script. Does nothing when the action is dry-activate.
sub record_unit {
    my ($fn, $unit) = @_;
    if ($action ne "dry-activate") {
        write_file($fn, { append => 1 }, "$unit\n");
    }
    return;
}

# The opposite of record_unit, removes a unit name from a file
sub unrecord_unit {
    my ($fn, $unit) = @_;
    if ($action ne "dry-activate") {
        edit_file(sub { s/^$unit\n//msx }, $fn);
    }
    return;
}

# Compare the contents of two unit files and return whether the unit
# needs to be restarted or reloaded. If the units differ, the service
# is restarted unless the only difference is `X-Reload-Triggers` in the
# `Unit` section. If this is the only modification, the unit is reloaded
# instead of restarted.
# Returns:
# - 0 if the units are equal
# - 1 if the units are different and a restart action is required
# - 2 if the units are different and a reload action is required
sub compare_units { ## no critic(Subroutines::ProhibitExcessComplexity)
    my ($cur_unit, $new_unit) = @_;
    my $ret = 0;
    # Keys to ignore in the [Unit] section
    my %unit_section_ignores = map { $_ => 1 } qw(
        X-Reload-Triggers
        Description Documentation
        OnFailure OnSuccess OnFailureJobMode
        IgnoreOnIsolate StopWhenUnneeded
        RefuseManualStart RefuseManualStop
        AllowIsolate CollectMode
        SourcePath
    );

    my $comp_array = sub {
      my ($a, $b) = @_;
      return join("\0", @{$a}) eq join("\0", @{$b});
    };

    # Comparison hash for the sections
    my %section_cmp = map { $_ => 1 } keys(%{$new_unit});
    # Iterate over the sections
    foreach my $section_name (keys(%{$cur_unit})) {
        # Missing section in the new unit?
        if (not exists($section_cmp{$section_name})) {
            # If the [Unit] section was removed, make sure that only keys
            # were in it that are ignored
            if ($section_name eq "Unit") {
                foreach my $ini_key (keys(%{$cur_unit->{"Unit"}})) {
                    if (not defined($unit_section_ignores{$ini_key})) {
                        return 1;
                    }
                }
                next; # check the next section
            } else {
                return 1;
            }
            if ($section_name eq "Unit" and %{$cur_unit->{"Unit"}} == 1 and defined(%{$cur_unit->{"Unit"}}{"X-Reload-Triggers"})) {
                # If a new [Unit] section was removed that only contained X-Reload-Triggers,
                # do nothing.
                next;
            } else {
                return 1;
            }
        }
        delete $section_cmp{$section_name};
        # Comparison hash for the section contents
        my %ini_cmp = map { $_ => 1 } keys(%{$new_unit->{$section_name}});
        # Iterate over the keys of the section
        foreach my $ini_key (keys(%{$cur_unit->{$section_name}})) {
            delete $ini_cmp{$ini_key};
            my @cur_value = @{$cur_unit->{$section_name}{$ini_key}};
            # If the key is missing in the new unit, they are different...
            if (not $new_unit->{$section_name}{$ini_key}) {
                # ... unless the key that is now missing is one of the ignored keys
                if ($section_name eq "Unit" and defined($unit_section_ignores{$ini_key})) {
                    next;
                }
                return 1;
            }
            my @new_value = @{$new_unit->{$section_name}{$ini_key}};
            # If the contents are different, the units are different
            if (not $comp_array->(\@cur_value, \@new_value)) {
                # Check if only the reload triggers changed or one of the ignored keys
                if ($section_name eq "Unit") {
                    if ($ini_key eq "X-Reload-Triggers") {
                        $ret = 2;
                        next;
                    } elsif (defined($unit_section_ignores{$ini_key})) {
                        next;
                    }
                }
                return 1;
            }
        }
        # A key was introduced that was missing in the previous unit
        if (%ini_cmp) {
            if ($section_name eq "Unit") {
                foreach my $ini_key (keys(%ini_cmp)) {
                    if ($ini_key eq "X-Reload-Triggers") {
                        $ret = 2;
                    } elsif (defined($unit_section_ignores{$ini_key})) {
                        next;
                    } else {
                        return 1;
                    }
                }
            } else {
                return 1;
            }
        };
    }
    # A section was introduced that was missing in the previous unit
    if (%section_cmp) {
        if (%section_cmp == 1 and defined($section_cmp{"Unit"})) {
            foreach my $ini_key (keys(%{$new_unit->{"Unit"}})) {
                if (not defined($unit_section_ignores{$ini_key})) {
                    return 1;
                } elsif ($ini_key eq "X-Reload-Triggers") {
                    $ret = 2;
                }
            }
        } else {
            return 1;
        }
    }

    return $ret;
}

# Called when a unit exists in both the old systemd and the new system and the units
# differ. This figures out of what units are to be stopped, restarted, reloaded, started, and skipped.
sub handle_modified_unit { ## no critic(Subroutines::ProhibitManyArgs, Subroutines::ProhibitExcessComplexity)
    my ($unit, $base_name, $new_unit_file, $new_unit_info, $active_cur, $units_to_stop, $units_to_start, $units_to_reload, $units_to_restart, $units_to_skip) = @_;

    if ($unit eq "sysinit.target" || $unit eq "basic.target" || $unit eq "multi-user.target" || $unit eq "graphical.target" || $unit =~ /\.path$/msx || $unit =~ /\.slice$/msx) {
        # Do nothing.  These cannot be restarted directly.

        # Slices and Paths don't have to be restarted since
        # properties (resource limits and inotify watches)
        # seem to get applied on daemon-reload.
    } elsif ($unit =~ /\.mount$/msx) {
        # Reload the changed mount unit to force a remount.
        # FIXME: only reload when Options= changed, restart otherwise
        $units_to_reload->{$unit} = 1;
        record_unit($reload_list_file, $unit);
    } elsif ($unit =~ /\.socket$/msx) {
        # FIXME: do something?
        # Attempt to fix this: https://github.com/NixOS/nixpkgs/pull/141192
        # Revert of the attempt: https://github.com/NixOS/nixpkgs/pull/147609
        # More details: https://github.com/NixOS/nixpkgs/issues/74899#issuecomment-981142430
    } else {
        my %new_unit_info = $new_unit_info ? %{$new_unit_info} : parse_unit($new_unit_file);
        if (parse_systemd_bool(\%new_unit_info, "Service", "X-ReloadIfChanged", 0) and not $units_to_restart->{$unit} and not $units_to_stop->{$unit}) {
            $units_to_reload->{$unit} = 1;
            record_unit($reload_list_file, $unit);
        }
        elsif (!parse_systemd_bool(\%new_unit_info, "Service", "X-RestartIfChanged", 1) || parse_systemd_bool(\%new_unit_info, "Unit", "RefuseManualStop", 0) || parse_systemd_bool(\%new_unit_info, "Unit", "X-OnlyManualStart", 0)) {
            $units_to_skip->{$unit} = 1;
        } else {
            # It doesn't make sense to stop and start non-services because
            # they can't have ExecStop=
            if (!parse_systemd_bool(\%new_unit_info, "Service", "X-StopIfChanged", 1) || $unit !~ /\.service$/msx) {
                # This unit should be restarted instead of
                # stopped and started.
                $units_to_restart->{$unit} = 1;
                record_unit($restart_list_file, $unit);
                # Remove from units to reload so we don't restart and reload
                if ($units_to_reload->{$unit}) {
                    delete $units_to_reload->{$unit};
                    unrecord_unit($reload_list_file, $unit);
                }
            } else {
                # If this unit is socket-activated, then stop the
                # socket unit(s) as well, and restart the
                # socket(s) instead of the service.
                my $socket_activated = 0;
                if ($unit =~ /\.service$/msx) {
                    my @sockets = split(/\s+/msx, join(" ", @{$new_unit_info{Service}{Sockets} // []}));
                    if (scalar(@sockets) == 0) {
                        @sockets = ("$base_name.socket");
                    }
                    foreach my $socket (@sockets) {
                        if (defined($active_cur->{$socket})) {
                            # We can now be sure this is a socket-activate unit

                            $units_to_stop->{$socket} = 1;
                            # Only restart sockets that actually
                            # exist in new configuration:
                            if (-e "$out/etc/systemd/system/$socket") {
                                $units_to_start->{$socket} = 1;
                                if ($units_to_start eq $units_to_restart) {
                                    record_unit($restart_list_file, $socket);
                                } else {
                                    record_unit($start_list_file, $socket);
                                }
                                $socket_activated = 1;
                            }
                            # Remove from units to reload so we don't restart and reload
                            if ($units_to_reload->{$unit}) {
                                delete $units_to_reload->{$unit};
                                unrecord_unit($reload_list_file, $unit);
                            }
                        }
                    }
                }

                # If the unit is not socket-activated, record
                # that this unit needs to be started below.
                # We write this to a file to ensure that the
                # service gets restarted if we're interrupted.
                if (!$socket_activated) {
                    $units_to_start->{$unit} = 1;
                    if ($units_to_start eq $units_to_restart) {
                        record_unit($restart_list_file, $unit);
                    } else {
                        record_unit($start_list_file, $unit);
                    }
                }

                $units_to_stop->{$unit} = 1;
                # Remove from units to reload so we don't restart and reload
                if ($units_to_reload->{$unit}) {
                    delete $units_to_reload->{$unit};
                    unrecord_unit($reload_list_file, $unit);
                }
            }
        }
    }
    return;
}

# Figure out what units need to be stopped, started, restarted or reloaded.
my (%units_to_stop, %units_to_skip, %units_to_start, %units_to_restart, %units_to_reload);

my %units_to_filter; # units not shown

%units_to_start = map { $_ => 1 }
    split(/\n/msx, read_file($start_list_file, err_mode => "quiet") // "");

%units_to_restart = map { $_ => 1 }
    split(/\n/msx, read_file($restart_list_file, err_mode => "quiet") // "");

%units_to_reload = map { $_ => 1 }
    split(/\n/msx, read_file($reload_list_file, err_mode => "quiet") // "");

my $active_cur = get_active_units();
while (my ($unit, $state) = each(%{$active_cur})) {
    my $base_unit = $unit;

    my $cur_unit_file = "/etc/systemd/system/$base_unit";
    my $new_unit_file = "$out/etc/systemd/system/$base_unit";

    # Detect template instances.
    if (!-e $cur_unit_file && !-e $new_unit_file && $unit =~ /^(.*)@[^\.]*\.(.*)$/msx) {
      $base_unit = "$1\@.$2";
      $cur_unit_file = "/etc/systemd/system/$base_unit";
      $new_unit_file = "$out/etc/systemd/system/$base_unit";
    }

    my $base_name = $base_unit;
    $base_name =~ s/\.[[:lower:]]*$//msx;

    if (-e $cur_unit_file && ($state->{state} eq "active" || $state->{state} eq "activating")) {
        if (! -e $new_unit_file || abs_path($new_unit_file) eq "/dev/null") {
            my %cur_unit_info = parse_unit($cur_unit_file);
            if (parse_systemd_bool(\%cur_unit_info, "Unit", "X-StopOnRemoval", 1)) {
                $units_to_stop{$unit} = 1;
            }
        }

        elsif ($unit =~ /\.target$/msx) {
            my %new_unit_info = parse_unit($new_unit_file);

            # Cause all active target units to be restarted below.
            # This should start most changed units we stop here as
            # well as any new dependencies (including new mounts and
            # swap devices).  FIXME: the suspend target is sometimes
            # active after the system has resumed, which probably
            # should not be the case.  Just ignore it.
            if ($unit ne "suspend.target" && $unit ne "hibernate.target" && $unit ne "hybrid-sleep.target") {
                if (!(parse_systemd_bool(\%new_unit_info, "Unit", "RefuseManualStart", 0) || parse_systemd_bool(\%new_unit_info, "Unit", "X-OnlyManualStart", 0))) {
                    $units_to_start{$unit} = 1;
                    record_unit($start_list_file, $unit);
                    # Don't spam the user with target units that always get started.
                    $units_to_filter{$unit} = 1;
                }
            }

            # Stop targets that have X-StopOnReconfiguration set.
            # This is necessary to respect dependency orderings
            # involving targets: if unit X starts after target Y and
            # target Y starts after unit Z, then if X and Z have both
            # changed, then X should be restarted after Z.  However,
            # if target Y is in the "active" state, X and Z will be
            # restarted at the same time because X's dependency on Y
            # is already satisfied.  Thus, we need to stop Y first.
            # Stopping a target generally has no effect on other units
            # (unless there is a PartOf dependency), so this is just a
            # bookkeeping thing to get systemd to do the right thing.
            if (parse_systemd_bool(\%new_unit_info, "Unit", "X-StopOnReconfiguration", 0)) {
                $units_to_stop{$unit} = 1;
            }
        }

        else {
            my %cur_unit_info = parse_unit($cur_unit_file);
            my %new_unit_info = parse_unit($new_unit_file);
            my $diff = compare_units(\%cur_unit_info, \%new_unit_info);
            if ($diff == 1) {
                handle_modified_unit($unit, $base_name, $new_unit_file, \%new_unit_info, $active_cur, \%units_to_stop, \%units_to_start, \%units_to_reload, \%units_to_restart, \%units_to_skip);
            } elsif ($diff == 2 and not $units_to_restart{$unit}) {
                $units_to_reload{$unit} = 1;
                record_unit($reload_list_file, $unit);
            }
        }
    }
}

# Converts a path to the name of a systemd mount unit that would be responsible
# for mounting this path.
sub path_to_unit_name {
    my ($path) = @_;
    # Use current version of systemctl binary before daemon is reexeced.
    open(my $cmd, "-|", "$cur_systemd/systemd-escape", "--suffix=mount", "-p", $path)
        or die "Unable to escape $path!\n";
    my $escaped = do { local $/ = undef; <$cmd> };
    chomp($escaped);
    close($cmd) or die("Unable to close systemd-escape pipe");
    return $escaped;
}

# Compare the previous and new fstab to figure out which filesystems
# need a remount or need to be unmounted.  New filesystems are mounted
# automatically by starting local-fs.target.  FIXME: might be nicer if
# we generated units for all mounts; then we could unify this with the
# unit checking code above.
my ($cur_fss, $cur_swaps) = parse_fstab("/etc/fstab");
my ($new_fss, $new_swaps) = parse_fstab("$out/etc/fstab");
foreach my $mount_point (keys(%{$cur_fss})) {
    my $cur = $cur_fss->{$mount_point};
    my $new = $new_fss->{$mount_point};
    my $unit = path_to_unit_name($mount_point);
    if (!defined($new)) {
        # Filesystem entry disappeared, so unmount it.
        $units_to_stop{$unit} = 1;
    } elsif ($cur->{fsType} ne $new->{fsType} || $cur->{device} ne $new->{device}) {
        # Filesystem type or device changed, so unmount and mount it.
        $units_to_stop{$unit} = 1;
        $units_to_start{$unit} = 1;
        record_unit($start_list_file, $unit);
    } elsif ($cur->{options} ne $new->{options}) {
        # Mount options changes, so remount it.
        $units_to_reload{$unit} = 1;
        record_unit($reload_list_file, $unit);
    }
}

# Also handles swap devices.
foreach my $device (keys(%{$cur_swaps})) {
    my $cur = $cur_swaps->{$device};
    my $new = $new_swaps->{$device};
    if (!defined($new)) {
        # Swap entry disappeared, so turn it off.  Can't use
        # "systemctl stop" here because systemd has lots of alias
        # units that prevent a stop from actually calling
        # "swapoff".
        if ($action ne "dry-activate") {
            print STDERR "would stop swap device: $device\n";
        } else {
            print STDERR "stopping swap device: $device\n";
            system("@utillinux@/sbin/swapoff", $device);
        }
    }
    # FIXME: update swap options (i.e. its priority).
}


# Should we have systemd re-exec itself?
my $cur_pid1_path = abs_path("/proc/1/exe") // "/unknown";
my $cur_systemd_system_config = abs_path("/etc/systemd/system.conf") // "/unknown";
my $new_pid1_path = abs_path("$new_systemd/lib/systemd/systemd") or die;
my $new_systemd_system_config = abs_path("$out/etc/systemd/system.conf") // "/unknown";

my $restart_systemd = $cur_pid1_path ne $new_pid1_path;
if ($cur_systemd_system_config ne $new_systemd_system_config) {
    $restart_systemd = 1;
}

# Takes an array of unit names and returns an array with the same elements,
# except all units that are also in the global variable `unitsToFilter`.
sub filter_units {
    my ($units) = @_;
    my @res;
    foreach my $unit (sort(keys(%{$units}))) {
        if (!defined($units_to_filter{$unit})) {
            push(@res, $unit);
        }
    }
    return @res;
}

my @units_to_stop_filtered = filter_units(\%units_to_stop);


# Show dry-run actions.
if ($action eq "dry-activate") {
    if (scalar(@units_to_stop_filtered) > 0) {
        print STDERR "would stop the following units: ", join(", ", @units_to_stop_filtered), "\n";
    }
    if (scalar(keys(%units_to_skip)) > 0) {
        print STDERR "would NOT stop the following changed units: ", join(", ", sort(keys(%units_to_skip))), "\n";
    }

    print STDERR "would activate the configuration...\n";
    system("$out/dry-activate", "$out");

    # Handle the activation script requesting the restart or reload of a unit.
    foreach (split(/\n/msx, read_file($dry_restart_by_activation_file, err_mode => "quiet") // "")) {
        my $unit = $_;
        my $base_unit = $unit;
        my $new_unit_file = "$out/etc/systemd/system/$base_unit";

        # Detect template instances.
        if (!-e $new_unit_file && $unit =~ /^(.*)@[^\.]*\.(.*)$/msx) {
          $base_unit = "$1\@.$2";
          $new_unit_file = "$out/etc/systemd/system/$base_unit";
        }

        my $base_name = $base_unit;
        $base_name =~ s/\.[[:lower:]]*$//msx;

        # Start units if they were not active previously
        if (not defined($active_cur->{$unit})) {
            $units_to_start{$unit} = 1;
            next;
        }

        handle_modified_unit($unit, $base_name, $new_unit_file, undef, $active_cur, \%units_to_restart, \%units_to_restart, \%units_to_reload, \%units_to_restart, \%units_to_skip);
    }
    unlink($dry_restart_by_activation_file);

    foreach (split(/\n/msx, read_file($dry_reload_by_activation_file, err_mode => "quiet") // "")) {
        my $unit = $_;

        if (defined($active_cur->{$unit}) and not $units_to_restart{$unit} and not $units_to_stop{$unit}) {
            $units_to_reload{$unit} = 1;
            record_unit($reload_list_file, $unit);
        }
    }
    unlink($dry_reload_by_activation_file);

    if ($restart_systemd) {
        print STDERR "would restart systemd\n";
    }
    if (scalar(keys(%units_to_reload)) > 0) {
        print STDERR "would reload the following units: ", join(", ", sort(keys(%units_to_reload))), "\n";
    }
    if (scalar(keys(%units_to_restart)) > 0) {
        print STDERR "would restart the following units: ", join(", ", sort(keys(%units_to_restart))), "\n";
    }
    my @units_to_start_filtered = filter_units(\%units_to_start);
    if (scalar(@units_to_start_filtered)) {
        print STDERR "would start the following units: ", join(", ", @units_to_start_filtered), "\n";
    }
    exit 0;
}


syslog(LOG_NOTICE, "switching to system configuration $out");

if (scalar(keys(%units_to_stop)) > 0) {
    if (scalar(@units_to_stop_filtered)) {
        print STDERR "stopping the following units: ", join(", ", @units_to_stop_filtered), "\n";
    }
    # Use current version of systemctl binary before daemon is reexeced.
    system("$cur_systemd/systemctl", "stop", "--", sort(keys(%units_to_stop)));
}

if (scalar(keys(%units_to_skip)) > 0) {
    print STDERR "NOT restarting the following changed units: ", join(", ", sort(keys(%units_to_skip))), "\n";
}

# Activate the new configuration (i.e., update /etc, make accounts,
# and so on).
my $res = 0;
print STDERR "activating the configuration...\n";
system("$out/activate", "$out") == 0 or $res = 2;

# Handle the activation script requesting the restart or reload of a unit.
foreach (split(/\n/msx, read_file($restart_by_activation_file, err_mode => "quiet") // "")) {
    my $unit = $_;
    my $base_unit = $unit;
    my $new_unit_file = "$out/etc/systemd/system/$base_unit";

    # Detect template instances.
    if (!-e $new_unit_file && $unit =~ /^(.*)@[^\.]*\.(.*)$/msx) {
      $base_unit = "$1\@.$2";
      $new_unit_file = "$out/etc/systemd/system/$base_unit";
    }

    my $base_name = $base_unit;
    $base_name =~ s/\.[[:lower:]]*$//msx;

    # Start units if they were not active previously
    if (not defined($active_cur->{$unit})) {
        $units_to_start{$unit} = 1;
        record_unit($start_list_file, $unit);
        next;
    }

    handle_modified_unit($unit, $base_name, $new_unit_file, undef, $active_cur, \%units_to_restart, \%units_to_restart, \%units_to_reload, \%units_to_restart, \%units_to_skip);
}
# We can remove the file now because it has been propagated to the other restart/reload files
unlink($restart_by_activation_file);

foreach (split(/\n/msx, read_file($reload_by_activation_file, err_mode => "quiet") // "")) {
    my $unit = $_;

    if (defined($active_cur->{$unit}) and not $units_to_restart{$unit} and not $units_to_stop{$unit}) {
        $units_to_reload{$unit} = 1;
        record_unit($reload_list_file, $unit);
    }
}
# We can remove the file now because it has been propagated to the other reload file
unlink($reload_by_activation_file);

# Restart systemd if necessary. Note that this is done using the
# current version of systemd, just in case the new one has trouble
# communicating with the running pid 1.
if ($restart_systemd) {
    print STDERR "restarting systemd...\n";
    system("$cur_systemd/systemctl", "daemon-reexec") == 0 or $res = 2;
}

# Forget about previously failed services.
system("$new_systemd/bin/systemctl", "reset-failed");

# Make systemd reload its units.
system("$new_systemd/bin/systemctl", "daemon-reload") == 0 or $res = 3;

# Reload user units
open(my $list_active_users, "-|", "$new_systemd/bin/loginctl", "list-users", "--no-legend") || die("Unable to call loginctl");
while (my $f = <$list_active_users>) {
    if ($f !~ /^\s*(?<uid>\d+)\s+(?<user>\S+)/msx) {
        next;
    }
    my ($uid, $name) = ($+{uid}, $+{user});
    print STDERR "reloading user units for $name...\n";

    system("@su@", "-s", "@shell@", "-l", $name, "-c",
           "export XDG_RUNTIME_DIR=/run/user/$uid; " .
           "$cur_systemd/systemctl --user daemon-reexec; " .
           "$new_systemd/bin/systemctl --user start nixos-activation.service");
}

close($list_active_users) || die("Unable to close the file handle to loginctl");

# Set the new tmpfiles
print STDERR "setting up tmpfiles\n";
system("$new_systemd/bin/systemd-tmpfiles", "--create", "--remove", "--exclude-prefix=/dev") == 0 or $res = 3;

# Before reloading we need to ensure that the units are still active. They may have been
# deactivated because one of their requirements got stopped. If they are inactive
# but should have been reloaded, the user probably expects them to be started.
if (scalar(keys(%units_to_reload)) > 0) {
    for my $unit (keys(%units_to_reload)) {
        if (!unit_is_active($unit)) {
            # Figure out if we need to start the unit
            my %unit_info = parse_unit("$out/etc/systemd/system/$unit");
            if (!(parse_systemd_bool(\%unit_info, "Unit", "RefuseManualStart", 0) || parse_systemd_bool(\%unit_info, "Unit", "X-OnlyManualStart", 0))) {
                $units_to_start{$unit} = 1;
                record_unit($start_list_file, $unit);
            }
            # Don't reload the unit, reloading would fail
            delete %units_to_reload{$unit};
            unrecord_unit($reload_list_file, $unit);
        }
    }
}
# Reload units that need it. This includes remounting changed mount
# units.
if (scalar(keys(%units_to_reload)) > 0) {
    print STDERR "reloading the following units: ", join(", ", sort(keys(%units_to_reload))), "\n";
    system("$new_systemd/bin/systemctl", "reload", "--", sort(keys(%units_to_reload))) == 0 or $res = 4;
    unlink($reload_list_file);
}

# Restart changed services (those that have to be restarted rather
# than stopped and started).
if (scalar(keys(%units_to_restart)) > 0) {
    print STDERR "restarting the following units: ", join(", ", sort(keys(%units_to_restart))), "\n";
    system("$new_systemd/bin/systemctl", "restart", "--", sort(keys(%units_to_restart))) == 0 or $res = 4;
    unlink($restart_list_file);
}

# Start all active targets, as well as changed units we stopped above.
# The latter is necessary because some may not be dependencies of the
# targets (i.e., they were manually started).  FIXME: detect units
# that are symlinks to other units.  We shouldn't start both at the
# same time because we'll get a "Failed to add path to set" error from
# systemd.
my @units_to_start_filtered = filter_units(\%units_to_start);
if (scalar(@units_to_start_filtered)) {
    print STDERR "starting the following units: ", join(", ", @units_to_start_filtered), "\n"
}
system("$new_systemd/bin/systemctl", "start", "--", sort(keys(%units_to_start))) == 0 or $res = 4;
unlink($start_list_file);


# Print failed and new units.
my (@failed, @new);
my $active_new = get_active_units();
while (my ($unit, $state) = each(%{$active_new})) {
    if ($state->{state} eq "failed") {
        push(@failed, $unit);
        next;
    }

    if ($state->{substate} eq "auto-restart") {
        # A unit in auto-restart substate is a failure *if* it previously failed to start
        open(my $main_status_fd, "-|", "$new_systemd/bin/systemctl", "show", "--value", "--property=ExecMainStatus", $unit) || die("Unable to call 'systemctl show'");
        my $main_status = do { local $/ = undef; <$main_status_fd> };
        close($main_status_fd) || die("Unable to close 'systemctl show' fd");
        chomp($main_status);

        if ($main_status ne "0") {
            push(@failed, $unit);
            next;
        }
    }

    # Ignore scopes since they are not managed by this script but rather
    # created and managed by third-party services via the systemd dbus API.
    # This only lists units that are not failed (including ones that are in auto-restart but have not failed previously)
    if ($state->{state} ne "failed" && !defined($active_cur->{$unit}) && $unit !~ /\.scope$/msx) {
        push(@new, $unit);
    }
}

if (scalar(@new) > 0) {
    print STDERR "the following new units were started: ", join(", ", sort(@new)), "\n"
}

if (scalar(@failed) > 0) {
    my @failed_sorted = sort(@failed);
    print STDERR "warning: the following units failed: ", join(", ", @failed_sorted), "\n\n";
    system("$new_systemd/bin/systemctl status --no-pager --full '" . join("' '", @failed_sorted) . "' >&2");
    $res = 4;
}

if ($res == 0) {
    syslog(LOG_NOTICE, "finished switching to system configuration $out");
} else {
    syslog(LOG_ERR, "switching to system configuration $out failed (status $res)");
}

exit($res);
