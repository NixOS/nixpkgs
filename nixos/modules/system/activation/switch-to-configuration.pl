#! @perl@/bin/perl

use strict;
use warnings;
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
# This also works for socket-activated units.
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

sub parseUnit {
    my ($filename) = @_;
    my $info = {};
    parseKeyValues($info, read_file($filename)) if -f $filename;
    parseKeyValues($info, read_file("${filename}.d/overrides.conf")) if -f "${filename}.d/overrides.conf";
    return $info;
}

sub parseKeyValues {
    my $info = shift;
    foreach my $line (@_) {
        # FIXME: not quite correct.
        $line =~ /^([^=]+)=(.*)$/ or next;
        $info->{$1} = $2;
    }
}

sub boolIsTrue {
    my ($s) = @_;
    return $s eq "yes" || $s eq "true";
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

    if ($unit eq "sysinit.target" || $unit eq "basic.target" || $unit eq "multi-user.target" || $unit eq "graphical.target" || $unit =~ /\.slice$/ || $unit =~ /\.path$/) {
        # Do nothing.  These cannot be restarted directly.
        # Slices and Paths don't have to be restarted since
        # properties (resource limits and inotify watches)
        # seem to get applied on daemon-reload.
    } elsif ($unit =~ /\.mount$/) {
        # Reload the changed mount unit to force a remount.
        $unitsToReload->{$unit} = 1;
        recordUnit($reloadListFile, $unit);
    } else {
        my $unitInfo = parseUnit($newUnitFile);
        if (boolIsTrue($unitInfo->{'X-ReloadIfChanged'} // "no")) {
            $unitsToReload->{$unit} = 1;
            recordUnit($reloadListFile, $unit);
        }
        elsif (!boolIsTrue($unitInfo->{'X-RestartIfChanged'} // "yes") || boolIsTrue($unitInfo->{'RefuseManualStop'} // "no") || boolIsTrue($unitInfo->{'X-OnlyManualStart'} // "no")) {
            $unitsToSkip->{$unit} = 1;
        } else {
            # If this unit is socket-activated, then stop it instead
            # of restarting it to make sure the new version of it is
            # socket-activated.
            my $socketActivated = 0;
            if ($unit =~ /\.service$/) {
                my @sockets = split / /, ($unitInfo->{Sockets} // "");
                if (scalar @sockets == 0) {
                    @sockets = ("$baseName.socket");
                }
                foreach my $socket (@sockets) {
                    if (-e "$out/etc/systemd/system/$socket") {
                        $socketActivated = 1;
                        $unitsToStop->{$unit} = 1;
                        # If the socket was not running previously,
                        # start it now.
                        if (not defined $activePrev->{$socket}) {
                            $unitsToStart->{$socket} = 1;
                        }
                    }
                }
            }

            # Don't do the rest of this for socket-activated units
            # because we handled these above where we stop the unit.
            # Since only services can be socket-activated, the
            # following condition always evaluates to `true` for
            # non-service units.
            if ($socketActivated) {
                return;
            }

            # If we are restarting a socket, also stop the corresponding
            # service. This is required because restarting a socket
            # when the service is already activated fails.
            if ($unit =~ /\.socket$/) {
                my $service = $unitInfo->{Service} // "";
                if ($service eq "") {
                    $service = "$baseName.service";
                }
                if (defined $activePrev->{$service}) {
                    $unitsToStop->{$service} = 1;
                }
                $unitsToRestart->{$unit} = 1;
                recordUnit($restartListFile, $unit);
            } else {
                # Always restart non-services instead of stopping and starting them
                # because it doesn't make sense to stop them with a config from
                # the old evaluation.
                if (!boolIsTrue($unitInfo->{'X-StopIfChanged'} // "yes") || $unit !~ /\.service$/) {
                    # This unit should be restarted instead of
                    # stopped and started.
                    $unitsToRestart->{$unit} = 1;
                    recordUnit($restartListFile, $unit);
                } else {
                    # We write to a file to ensure that the
                    # service gets restarted if we're interrupted.
                    $unitsToStart->{$unit} = 1;
                    recordUnit($startListFile, $unit);
                    $unitsToStop->{$unit} = 1;
                }
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
            my $unitInfo = parseUnit($prevUnitFile);
            $unitsToStop{$unit} = 1 if boolIsTrue($unitInfo->{'X-StopOnRemoval'} // "yes");
        }

        elsif ($unit =~ /\.target$/) {
            my $unitInfo = parseUnit($newUnitFile);

            # Cause all active target units to be restarted below.
            # This should start most changed units we stop here as
            # well as any new dependencies (including new mounts and
            # swap devices).  FIXME: the suspend target is sometimes
            # active after the system has resumed, which probably
            # should not be the case.  Just ignore it.
            if ($unit ne "suspend.target" && $unit ne "hibernate.target" && $unit ne "hybrid-sleep.target") {
                unless (boolIsTrue($unitInfo->{'RefuseManualStart'} // "no") || boolIsTrue($unitInfo->{'X-OnlyManualStart'} // "no")) {
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
            if (boolIsTrue($unitInfo->{'X-StopOnReconfiguration'} // "no")) {
                $unitsToStop{$unit} = 1;
            }
        }

        elsif (fingerprintUnit($prevUnitFile) ne fingerprintUnit($newUnitFile)) {
            handleModifiedUnit($unit, $baseName, $newUnitFile, $activePrev, \%unitsToStop, \%unitsToStart, \%unitsToReload, \%unitsToRestart, %unitsToSkip);
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
my $newSystemd = abs_path("@systemd@/lib/systemd/systemd") or die;
my $restartSystemd = $prevSystemd ne $newSystemd;


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
    my %unitsToAlsoStop;
    my %unitsToAlsoSkip;
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

        handleModifiedUnit($unit, $baseName, $newUnitFile, $activePrev, \%unitsToAlsoStop, \%unitsToStart, \%unitsToReload, \%unitsToRestart, %unitsToAlsoSkip);
    }
    unlink($dryRestartByActivationFile);

    my @unitsToAlsoStopFiltered = filterUnits(\%unitsToAlsoStop);
    if (scalar(keys %unitsToAlsoStop) > 0) {
        print STDERR "would stop the following units as well: ", join(", ", @unitsToAlsoStopFiltered), "\n"
            if scalar @unitsToAlsoStopFiltered;
    }

    print STDERR "would NOT restart the following changed units as well: ", join(", ", sort(keys %unitsToAlsoSkip)), "\n"
        if scalar(keys %unitsToAlsoSkip) > 0;

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
# We can only restart and reload (not stop/start) because the units to be
# stopped are already stopped before the activation script is run. We do however
# make an exception for services that are socket-activated and that have to be stopped
# instead of being restarted.
my %unitsToAlsoStop;
my %unitsToAlsoSkip;
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

    handleModifiedUnit($unit, $baseName, $newUnitFile, $activePrev, \%unitsToAlsoStop, \%unitsToStart, \%unitsToReload, \%unitsToRestart, %unitsToAlsoSkip);
}
unlink($restartByActivationFile);

my @unitsToAlsoStopFiltered = filterUnits(\%unitsToAlsoStop);
if (scalar(keys %unitsToAlsoStop) > 0) {
    print STDERR "stopping the following units as well: ", join(", ", @unitsToAlsoStopFiltered), "\n"
        if scalar @unitsToAlsoStopFiltered;
    system("$curSystemd/systemctl", "stop", "--", sort(keys %unitsToAlsoStop));
}

print STDERR "NOT restarting the following changed units as well: ", join(", ", sort(keys %unitsToAlsoSkip)), "\n"
    if scalar(keys %unitsToAlsoSkip) > 0;

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

    # We split the units to be restarted into sockets and non-sockets.
    # This is because restarting sockets may fail which is not bad by
    # itself but which will prevent changes on the sockets. We usually
    # restart the socket and stop the service before that. Restarting
    # the socket will fail however when the service was re-activated
    # in the meantime. There is no proper way to prevent that from happening.
    my @unitsWithErrorHandling = grep { $_ !~ /\.socket$/ } sort(keys %unitsToRestart);
    my @unitsWithoutErrorHandling = grep { $_ =~ /\.socket$/ } sort(keys %unitsToRestart);

    if (scalar(@unitsWithErrorHandling) > 0) {
        system("@systemd@/bin/systemctl", "restart", "--", @unitsWithErrorHandling) == 0 or $res = 4;
    }
    if (scalar(@unitsWithoutErrorHandling) > 0) {
        # Don't print warnings from systemctl
        no warnings 'once';
        open(OLDERR, ">&", \*STDERR);
        close(STDERR);

        my $ret = system("@systemd@/bin/systemctl", "restart", "--", @unitsWithoutErrorHandling);

        # Print stderr again
        open(STDERR, ">&OLDERR");

        if ($ret ne 0) {
            print STDERR "warning: some sockets failed to restart. Please check your journal (journalctl -eb) and act accordingly.\n";
        }
    }
    unlink($restartListFile);
    unlink($restartByActivationFile);
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
    }
    elsif ($state->{state} eq "auto-restart") {
        # A unit in auto-restart state is a failure *if* it previously failed to start
        my $lines = `@systemd@/bin/systemctl show '$unit'`;
        my $info = {};
        parseKeyValues($info, split("\n", $lines));

        if ($info->{ExecMainStatus} ne '0') {
            push @failed, $unit;
        }
    }
    # Ignore scopes since they are not managed by this script but rather
    # created and managed by third-party services via the systemd dbus API.
    elsif ($state->{state} ne "failed" && !defined $activePrev->{$unit} && $unit !~ /\.scope$/) {
        push @new, $unit;
    }
}

print STDERR "the following new units were started: ", join(", ", sort(@new)), "\n"
    if scalar @new > 0;

if (scalar @failed > 0) {
    print STDERR "warning: the following units failed: ", join(", ", sort(@failed)), "\n";
    foreach my $unit (@failed) {
        print STDERR "\n";
        system("COLUMNS=1000 @systemd@/bin/systemctl status --no-pager '$unit' >&2");
    }
    $res = 4;
}

if ($res == 0) {
    syslog(LOG_NOTICE, "finished switching to system configuration $out");
} else {
    syslog(LOG_ERR, "switching to system configuration $out failed (status $res)");
}

exit $res;
