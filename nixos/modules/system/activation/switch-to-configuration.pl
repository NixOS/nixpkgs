#! @perl@/bin/perl

use strict;
use warnings;
use Config::IniFiles;
use File::Path qw(make_path);
use File::Basename;
use File::Slurp;
use Net::DBus;
use Sys::Syslog qw(:standard :macros);
use Cwd 'abs_path';

my $out = "@out@";

my $curSystemd = abs_path("/run/current-system/sw/bin");

# To be robust against interruption, record what units need to be started etc.
my $startListFile = "/run/nixos/start-list";
my $restartListFile = "/run/nixos/restart-list";
my $reloadListFile = "/run/nixos/reload-list";

# Parse restart/reload requests by the activation script.
# Activation scripts may write newline-separated units to this
# file and switch-to-configuration will handle them. While
# `stopIfChanged = true` is ignored, switch-to-configuration will
# handle `restartIfChanged = false` and `reloadIfChanged = true`.
my $restartByActivationFile = "/run/nixos/activation-restart-list";
my $dryRestartByActivationFile = "/run/nixos/dry-activation-restart-list";

make_path("/run/nixos", { mode => oct(755) });

my $action = shift @ARGV;

if ("@localeArchive@" ne "") {
    $ENV{LOCALE_ARCHIVE} = "@localeArchive@";
}

if (!defined $action || ($action ne "switch" && $action ne "boot" && $action ne "test" && $action ne "dry-activate")) {
    print STDERR <<EOF;
Usage: $0 [switch|boot|test]

switch:       make the configuration the boot default and activate now
boot:         make the configuration the boot default
test:         activate the configuration, but don\'t make it the boot default
dry-activate: show what would be done if this configuration were activated
EOF
    exit 1;
}

$ENV{NIXOS_ACTION} = $action;

# This is a NixOS installation if it has /etc/NIXOS or a proper
# /etc/os-release.
die "This is not a NixOS installation!\n" unless
    -f "/etc/NIXOS" || (read_file("/etc/os-release", err_mode => 'quiet') // "") =~ /ID=nixos/s;

openlog("nixos", "", LOG_USER);

# Install or update the bootloader.
if ($action eq "switch" || $action eq "boot") {
    system("@installBootLoader@ $out") == 0 or exit 1;
}

# Just in case the new configuration hangs the system, do a sync now.
system("@coreutils@/bin/sync", "-f", "/nix/store") unless ($ENV{"NIXOS_NO_SYNC"} // "") eq "1";

exit 0 if $action eq "boot";

# Check if we can activate the new configuration.
my $oldVersion = read_file("/run/current-system/init-interface-version", err_mode => 'quiet') // "";
my $newVersion = read_file("$out/init-interface-version");

if ($newVersion ne $oldVersion) {
    print STDERR <<EOF;
Warning: the new NixOS configuration has an ‘init’ that is
incompatible with the current configuration.  The new configuration
won\'t take effect until you reboot the system.
EOF
    exit 100;
}

# Ignore SIGHUP so that we're not killed if we're running on (say)
# virtual console 1 and we restart the "tty1" unit.
$SIG{PIPE} = "IGNORE";

sub getActiveUnits {
    my $mgr = Net::DBus->system->get_service("org.freedesktop.systemd1")->get_object("/org/freedesktop/systemd1");
    my $units = $mgr->ListUnitsByPatterns([], []);
    my $res = {};
    for my $item (@$units) {
        my ($id, $description, $load_state, $active_state, $sub_state,
            $following, $unit_path, $job_id, $job_type, $job_path) = @$item;
        next unless $following eq '';
        next if $job_id == 0 and $active_state eq 'inactive';
        $res->{$id} = { load => $load_state, state => $active_state, substate => $sub_state };
    }
    return $res;
}

sub parseFstab {
    my ($filename) = @_;
    my ($fss, $swaps);
    foreach my $line (read_file($filename, err_mode => 'quiet')) {
        chomp $line;
        $line =~ s/^\s*#.*//;
        next if $line =~ /^\s*$/;
        my @xs = split / /, $line;
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
sub parseSystemdIni {
    my ($unitContents, $path) = @_;
    # Tie the ini file to a hash for easier access
    my %fileContents;
    tie %fileContents, "Config::IniFiles", (-file => $path, -allowempty => 1, -allowcontinue => 1);

    # Copy over all sections
    foreach my $sectionName (keys %fileContents) {
        # Copy over all keys
        foreach my $iniKey (keys %{$fileContents{$sectionName}}) {
            # Ensure the value is an array so it's easier to work with
            my $iniValue = $fileContents{$sectionName}{$iniKey};
            my @iniValues;
            if (ref($iniValue) eq "ARRAY") {
                @iniValues = @{$iniValue};
            } else {
                @iniValues = $iniValue;
            }
            # Go over all values
            for my $iniValue (@iniValues) {
                # If a value is empty, it's an override that tells us to clean the value
                if ($iniValue eq "") {
                    delete $unitContents->{$sectionName}->{$iniKey};
                    next;
                }
                push(@{$unitContents->{$sectionName}->{$iniKey}}, $iniValue);
            }
        }
    }
    return;
}

# This subroutine takes the path to a systemd configuration file (like a unit configuration),
# parses it, and returns a hash that contains the contents. The contents of this hash are
# explained in the `parseSystemdIni` subroutine. Neither the sections nor the keys inside
# the sections are consistently sorted.
#
# If a directory with the same basename ending in .d exists next to the unit file, it will be
# assumed to contain override files which will be parsed as well and handled properly.
sub parseUnit {
    my ($unitPath) = @_;

    # Parse the main unit and all overrides
    my %unitData;
    parseSystemdIni(\%unitData, $_) for glob("${unitPath}{,.d/*.conf}");
    return %unitData;
}

# Checks whether a specified boolean in a systemd unit is true
# or false, with a default that is applied when the value is not set.
sub parseSystemdBool {
    my ($unitConfig, $sectionName, $boolName, $default) = @_;

    my @values = @{$unitConfig->{$sectionName}{$boolName} // []};
    # Return default if value is not set
    if (scalar @values lt 1 || not defined $values[-1]) {
        return $default;
    }
    # If value is defined multiple times, use the last definition
    my $last = $values[-1];
    # These are valid values as of systemd.syntax(7)
    return $last eq "1" || $last eq "yes" || $last eq "true" || $last eq "on";
}

sub recordUnit {
    my ($fn, $unit) = @_;
    write_file($fn, { append => 1 }, "$unit\n") if $action ne "dry-activate";
}

# As a fingerprint for determining whether a unit has changed, we use
# its absolute path. If it has an override file, we append *its*
# absolute path as well.
sub fingerprintUnit {
    my ($s) = @_;
    return abs_path($s) . (-f "${s}.d/overrides.conf" ? " " . abs_path "${s}.d/overrides.conf" : "");
}

sub handleModifiedUnit {
    my ($unit, $baseName, $newUnitFile, $activePrev, $unitsToStop, $unitsToStart, $unitsToReload, $unitsToRestart, $unitsToSkip) = @_;

    if ($unit eq "sysinit.target" || $unit eq "basic.target" || $unit eq "multi-user.target" || $unit eq "graphical.target" || $unit =~ /\.path$/ || $unit =~ /\.slice$/) {
        # Do nothing.  These cannot be restarted directly.

        # Slices and Paths don't have to be restarted since
        # properties (resource limits and inotify watches)
        # seem to get applied on daemon-reload.
    } elsif ($unit =~ /\.mount$/) {
        # Reload the changed mount unit to force a remount.
        $unitsToReload->{$unit} = 1;
        recordUnit($reloadListFile, $unit);
    } elsif ($unit =~ /\.socket$/) {
        # FIXME: do something?
        # Attempt to fix this: https://github.com/NixOS/nixpkgs/pull/141192
        # Revert of the attempt: https://github.com/NixOS/nixpkgs/pull/147609
        # More details: https://github.com/NixOS/nixpkgs/issues/74899#issuecomment-981142430
    } else {
        my %unitInfo = parseUnit($newUnitFile);
        if (parseSystemdBool(\%unitInfo, "Service", "X-ReloadIfChanged", 0)) {
            $unitsToReload->{$unit} = 1;
            recordUnit($reloadListFile, $unit);
        }
        elsif (!parseSystemdBool(\%unitInfo, "Service", "X-RestartIfChanged", 1) || parseSystemdBool(\%unitInfo, "Unit", "RefuseManualStop", 0) || parseSystemdBool(\%unitInfo, "Unit", "X-OnlyManualStart", 0)) {
            $unitsToSkip->{$unit} = 1;
        } else {
            # It doesn't make sense to stop and start non-services because
            # they can't have ExecStop=
            if (!parseSystemdBool(\%unitInfo, "Service", "X-StopIfChanged", 1) || $unit !~ /\.service$/) {
                # This unit should be restarted instead of
                # stopped and started.
                $unitsToRestart->{$unit} = 1;
                recordUnit($restartListFile, $unit);
            } else {
                # If this unit is socket-activated, then stop the
                # socket unit(s) as well, and restart the
                # socket(s) instead of the service.
                my $socketActivated = 0;
                if ($unit =~ /\.service$/) {
                    my @sockets = split(/ /, join(" ", @{$unitInfo{Service}{Sockets} // []}));
                    if (scalar @sockets == 0) {
                        @sockets = ("$baseName.socket");
                    }
                    foreach my $socket (@sockets) {
                        if (defined $activePrev->{$socket}) {
                            $unitsToStop->{$socket} = 1;
                            # Only restart sockets that actually
                            # exist in new configuration:
                            if (-e "$out/etc/systemd/system/$socket") {
                                $unitsToStart->{$socket} = 1;
                                recordUnit($startListFile, $socket);
                                $socketActivated = 1;
                            }
                        }
                    }
                }

                # If the unit is not socket-activated, record
                # that this unit needs to be started below.
                # We write this to a file to ensure that the
                # service gets restarted if we're interrupted.
                if (!$socketActivated) {
                    $unitsToStart->{$unit} = 1;
                    recordUnit($startListFile, $unit);
                }

                $unitsToStop->{$unit} = 1;
            }
        }
    }
}

# Figure out what units need to be stopped, started, restarted or reloaded.
my (%unitsToStop, %unitsToSkip, %unitsToStart, %unitsToRestart, %unitsToReload);

my %unitsToFilter; # units not shown

$unitsToStart{$_} = 1 foreach
    split('\n', read_file($startListFile, err_mode => 'quiet') // "");

$unitsToRestart{$_} = 1 foreach
    split('\n', read_file($restartListFile, err_mode => 'quiet') // "");

$unitsToReload{$_} = 1 foreach
    split('\n', read_file($reloadListFile, err_mode => 'quiet') // "");

my $activePrev = getActiveUnits;
while (my ($unit, $state) = each %{$activePrev}) {
    my $baseUnit = $unit;

    my $prevUnitFile = "/etc/systemd/system/$baseUnit";
    my $newUnitFile = "$out/etc/systemd/system/$baseUnit";

    # Detect template instances.
    if (!-e $prevUnitFile && !-e $newUnitFile && $unit =~ /^(.*)@[^\.]*\.(.*)$/) {
      $baseUnit = "$1\@.$2";
      $prevUnitFile = "/etc/systemd/system/$baseUnit";
      $newUnitFile = "$out/etc/systemd/system/$baseUnit";
    }

    my $baseName = $baseUnit;
    $baseName =~ s/\.[a-z]*$//;

    if (-e $prevUnitFile && ($state->{state} eq "active" || $state->{state} eq "activating")) {
        if (! -e $newUnitFile || abs_path($newUnitFile) eq "/dev/null") {
            my %unitInfo = parseUnit($prevUnitFile);
            $unitsToStop{$unit} = 1 if parseSystemdBool(\%unitInfo, "Unit", "X-StopOnRemoval", 1);
        }

        elsif ($unit =~ /\.target$/) {
            my %unitInfo = parseUnit($newUnitFile);

            # Cause all active target units to be restarted below.
            # This should start most changed units we stop here as
            # well as any new dependencies (including new mounts and
            # swap devices).  FIXME: the suspend target is sometimes
            # active after the system has resumed, which probably
            # should not be the case.  Just ignore it.
            if ($unit ne "suspend.target" && $unit ne "hibernate.target" && $unit ne "hybrid-sleep.target") {
                unless (parseSystemdBool(\%unitInfo, "Unit", "RefuseManualStart", 0) || parseSystemdBool(\%unitInfo, "Unit", "X-OnlyManualStart", 0)) {
                    $unitsToStart{$unit} = 1;
                    recordUnit($startListFile, $unit);
                    # Don't spam the user with target units that always get started.
                    $unitsToFilter{$unit} = 1;
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
            if (parseSystemdBool(\%unitInfo, "Unit", "X-StopOnReconfiguration", 0)) {
                $unitsToStop{$unit} = 1;
            }
        }

        elsif (fingerprintUnit($prevUnitFile) ne fingerprintUnit($newUnitFile)) {
            handleModifiedUnit($unit, $baseName, $newUnitFile, $activePrev, \%unitsToStop, \%unitsToStart, \%unitsToReload, \%unitsToRestart, \%unitsToSkip);
        }
    }
}

sub pathToUnitName {
    my ($path) = @_;
    # Use current version of systemctl binary before daemon is reexeced.
    open my $cmd, "-|", "$curSystemd/systemd-escape", "--suffix=mount", "-p", $path
        or die "Unable to escape $path!\n";
    my $escaped = join "", <$cmd>;
    chomp $escaped;
    close $cmd or die;
    return $escaped;
}

sub unique {
    my %seen;
    my @res;
    foreach my $name (@_) {
        next if $seen{$name};
        $seen{$name} = 1;
        push @res, $name;
    }
    return @res;
}

# Compare the previous and new fstab to figure out which filesystems
# need a remount or need to be unmounted.  New filesystems are mounted
# automatically by starting local-fs.target.  FIXME: might be nicer if
# we generated units for all mounts; then we could unify this with the
# unit checking code above.
my ($prevFss, $prevSwaps) = parseFstab "/etc/fstab";
my ($newFss, $newSwaps) = parseFstab "$out/etc/fstab";
foreach my $mountPoint (keys %$prevFss) {
    my $prev = $prevFss->{$mountPoint};
    my $new = $newFss->{$mountPoint};
    my $unit = pathToUnitName($mountPoint);
    if (!defined $new) {
        # Filesystem entry disappeared, so unmount it.
        $unitsToStop{$unit} = 1;
    } elsif ($prev->{fsType} ne $new->{fsType} || $prev->{device} ne $new->{device}) {
        # Filesystem type or device changed, so unmount and mount it.
        $unitsToStop{$unit} = 1;
        $unitsToStart{$unit} = 1;
        recordUnit($startListFile, $unit);
    } elsif ($prev->{options} ne $new->{options}) {
        # Mount options changes, so remount it.
        $unitsToReload{$unit} = 1;
        recordUnit($reloadListFile, $unit);
    }
}

# Also handles swap devices.
foreach my $device (keys %$prevSwaps) {
    my $prev = $prevSwaps->{$device};
    my $new = $newSwaps->{$device};
    if (!defined $new) {
        # Swap entry disappeared, so turn it off.  Can't use
        # "systemctl stop" here because systemd has lots of alias
        # units that prevent a stop from actually calling
        # "swapoff".
        print STDERR "stopping swap device: $device\n";
        system("@utillinux@/sbin/swapoff", $device);
    }
    # FIXME: update swap options (i.e. its priority).
}


# Should we have systemd re-exec itself?
my $prevSystemd = abs_path("/proc/1/exe") // "/unknown";
my $prevSystemdSystemConfig = abs_path("/etc/systemd/system.conf") // "/unknown";
my $newSystemd = abs_path("@systemd@/lib/systemd/systemd") or die;
my $newSystemdSystemConfig = abs_path("$out/etc/systemd/system.conf") // "/unknown";

my $restartSystemd = $prevSystemd ne $newSystemd;
if ($prevSystemdSystemConfig ne $newSystemdSystemConfig) {
    $restartSystemd = 1;
}


sub filterUnits {
    my ($units) = @_;
    my @res;
    foreach my $unit (sort(keys %{$units})) {
        push @res, $unit if !defined $unitsToFilter{$unit};
    }
    return @res;
}

my @unitsToStopFiltered = filterUnits(\%unitsToStop);


# Show dry-run actions.
if ($action eq "dry-activate") {
    print STDERR "would stop the following units: ", join(", ", @unitsToStopFiltered), "\n"
        if scalar @unitsToStopFiltered > 0;
    print STDERR "would NOT stop the following changed units: ", join(", ", sort(keys %unitsToSkip)), "\n"
        if scalar(keys %unitsToSkip) > 0;

    print STDERR "would activate the configuration...\n";
    system("$out/dry-activate", "$out");

    # Handle the activation script requesting the restart or reload of a unit.
    foreach (split('\n', read_file($dryRestartByActivationFile, err_mode => 'quiet') // "")) {
        my $unit = $_;
        my $baseUnit = $unit;
        my $newUnitFile = "$out/etc/systemd/system/$baseUnit";

        # Detect template instances.
        if (!-e $newUnitFile && $unit =~ /^(.*)@[^\.]*\.(.*)$/) {
          $baseUnit = "$1\@.$2";
          $newUnitFile = "$out/etc/systemd/system/$baseUnit";
        }

        my $baseName = $baseUnit;
        $baseName =~ s/\.[a-z]*$//;

        # Start units if they were not active previously
        if (not defined $activePrev->{$unit}) {
            $unitsToStart{$unit} = 1;
            next;
        }

        handleModifiedUnit($unit, $baseName, $newUnitFile, $activePrev, \%unitsToRestart, \%unitsToRestart, \%unitsToReload, \%unitsToRestart, \%unitsToSkip);
    }
    unlink($dryRestartByActivationFile);

    print STDERR "would restart systemd\n" if $restartSystemd;
    print STDERR "would reload the following units: ", join(", ", sort(keys %unitsToReload)), "\n"
        if scalar(keys %unitsToReload) > 0;
    print STDERR "would restart the following units: ", join(", ", sort(keys %unitsToRestart)), "\n"
        if scalar(keys %unitsToRestart) > 0;
    my @unitsToStartFiltered = filterUnits(\%unitsToStart);
    print STDERR "would start the following units: ", join(", ", @unitsToStartFiltered), "\n"
        if scalar @unitsToStartFiltered;
    exit 0;
}


syslog(LOG_NOTICE, "switching to system configuration $out");

if (scalar (keys %unitsToStop) > 0) {
    print STDERR "stopping the following units: ", join(", ", @unitsToStopFiltered), "\n"
        if scalar @unitsToStopFiltered;
    # Use current version of systemctl binary before daemon is reexeced.
    system("$curSystemd/systemctl", "stop", "--", sort(keys %unitsToStop));
}

print STDERR "NOT restarting the following changed units: ", join(", ", sort(keys %unitsToSkip)), "\n"
    if scalar(keys %unitsToSkip) > 0;

# Activate the new configuration (i.e., update /etc, make accounts,
# and so on).
my $res = 0;
print STDERR "activating the configuration...\n";
system("$out/activate", "$out") == 0 or $res = 2;

# Handle the activation script requesting the restart or reload of a unit.
foreach (split('\n', read_file($restartByActivationFile, err_mode => 'quiet') // "")) {
    my $unit = $_;
    my $baseUnit = $unit;
    my $newUnitFile = "$out/etc/systemd/system/$baseUnit";

    # Detect template instances.
    if (!-e $newUnitFile && $unit =~ /^(.*)@[^\.]*\.(.*)$/) {
      $baseUnit = "$1\@.$2";
      $newUnitFile = "$out/etc/systemd/system/$baseUnit";
    }

    my $baseName = $baseUnit;
    $baseName =~ s/\.[a-z]*$//;

    # Start units if they were not active previously
    if (not defined $activePrev->{$unit}) {
        $unitsToStart{$unit} = 1;
        recordUnit($startListFile, $unit);
        next;
    }

    handleModifiedUnit($unit, $baseName, $newUnitFile, $activePrev, \%unitsToRestart, \%unitsToRestart, \%unitsToReload, \%unitsToRestart, \%unitsToSkip);
}
# We can remove the file now because it has been propagated to the other restart/reload files
unlink($restartByActivationFile);

# Restart systemd if necessary. Note that this is done using the
# current version of systemd, just in case the new one has trouble
# communicating with the running pid 1.
if ($restartSystemd) {
    print STDERR "restarting systemd...\n";
    system("$curSystemd/systemctl", "daemon-reexec") == 0 or $res = 2;
}

# Forget about previously failed services.
system("@systemd@/bin/systemctl", "reset-failed");

# Make systemd reload its units.
system("@systemd@/bin/systemctl", "daemon-reload") == 0 or $res = 3;

# Reload user units
open my $listActiveUsers, '-|', '@systemd@/bin/loginctl', 'list-users', '--no-legend';
while (my $f = <$listActiveUsers>) {
    next unless $f =~ /^\s*(?<uid>\d+)\s+(?<user>\S+)/;
    my ($uid, $name) = ($+{uid}, $+{user});
    print STDERR "reloading user units for $name...\n";

    system("@su@", "-s", "@shell@", "-l", $name, "-c",
           "export XDG_RUNTIME_DIR=/run/user/$uid; " .
           "$curSystemd/systemctl --user daemon-reexec; " .
           "@systemd@/bin/systemctl --user start nixos-activation.service");
}

close $listActiveUsers;

# Set the new tmpfiles
print STDERR "setting up tmpfiles\n";
system("@systemd@/bin/systemd-tmpfiles", "--create", "--remove", "--exclude-prefix=/dev") == 0 or $res = 3;

# Reload units that need it. This includes remounting changed mount
# units.
if (scalar(keys %unitsToReload) > 0) {
    print STDERR "reloading the following units: ", join(", ", sort(keys %unitsToReload)), "\n";
    system("@systemd@/bin/systemctl", "reload", "--", sort(keys %unitsToReload)) == 0 or $res = 4;
    unlink($reloadListFile);
}

# Restart changed services (those that have to be restarted rather
# than stopped and started).
if (scalar(keys %unitsToRestart) > 0) {
    print STDERR "restarting the following units: ", join(", ", sort(keys %unitsToRestart)), "\n";
    system("@systemd@/bin/systemctl", "restart", "--", sort(keys %unitsToRestart)) == 0 or $res = 4;
    unlink($restartListFile);
}

# Start all active targets, as well as changed units we stopped above.
# The latter is necessary because some may not be dependencies of the
# targets (i.e., they were manually started).  FIXME: detect units
# that are symlinks to other units.  We shouldn't start both at the
# same time because we'll get a "Failed to add path to set" error from
# systemd.
my @unitsToStartFiltered = filterUnits(\%unitsToStart);
print STDERR "starting the following units: ", join(", ", @unitsToStartFiltered), "\n"
    if scalar @unitsToStartFiltered;
system("@systemd@/bin/systemctl", "start", "--", sort(keys %unitsToStart)) == 0 or $res = 4;
unlink($startListFile);


# Print failed and new units.
my (@failed, @new);
my $activeNew = getActiveUnits;
while (my ($unit, $state) = each %{$activeNew}) {
    if ($state->{state} eq "failed") {
        push @failed, $unit;
        next;
    }

    if ($state->{substate} eq "auto-restart") {
        # A unit in auto-restart substate is a failure *if* it previously failed to start
        my $main_status = `@systemd@/bin/systemctl show --value --property=ExecMainStatus '$unit'`;
        chomp($main_status);

        if ($main_status ne "0") {
            push @failed, $unit;
            next;
        }
    }

    # Ignore scopes since they are not managed by this script but rather
    # created and managed by third-party services via the systemd dbus API.
    # This only lists units that are not failed (including ones that are in auto-restart but have not failed previously)
    if ($state->{state} ne "failed" && !defined $activePrev->{$unit} && $unit !~ /\.scope$/msx) {
        push @new, $unit;
    }
}

if (scalar @new > 0) {
    print STDERR "the following new units were started: ", join(", ", sort(@new)), "\n"
}

if (scalar @failed > 0) {
    my @failed_sorted = sort @failed;
    print STDERR "warning: the following units failed: ", join(", ", @failed_sorted), "\n\n";
    system "@systemd@/bin/systemctl status --no-pager --full '" . join("' '", @failed_sorted) . "' >&2";
    $res = 4;
}

if ($res == 0) {
    syslog(LOG_NOTICE, "finished switching to system configuration $out");
} else {
    syslog(LOG_ERR, "switching to system configuration $out failed (status $res)");
}

exit $res;
