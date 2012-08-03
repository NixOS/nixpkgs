#! @perl@

use strict;
use warnings;
use File::Basename;
use File::Slurp;
use Cwd 'abs_path';

my $restartListFile = "/run/systemd/restart-list";

my $action = shift @ARGV;

if (!defined $action || ($action ne "switch" && $action ne "boot" && $action ne "test")) {
    print STDERR <<EOF;
Usage: $0 [switch|boot|test]

switch: make the configuration the boot default and activate now
boot:   make the configuration the boot default
test:   activate the configuration, but don\'t make it the boot default
EOF
    exit 1;
}

die "This is not a NixOS installation (/etc/NIXOS is missing)!\n" unless -f "/etc/NIXOS";

# Install or update the bootloader.
if ($action eq "switch" || $action eq "boot") {
    system("@installBootLoader@ @out@") == 0 or exit 1;
    exit 0 if $action eq "boot";
}

# Check if we can activate the new configuration.
my $oldVersion = read_file("/run/current-system/init-interface-version", err_mode => 'quiet') // "";
my $newVersion = read_file("@out@/init-interface-version");

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
    # FIXME: use D-Bus or whatever to query this, since parsing the
    # output of list-units is likely to break.
    my $lines = `@systemd@/bin/systemctl list-units --full`;
    my $res = {};
    foreach my $line (split '\n', $lines) {
        chomp $line;
        last if $line eq "";
        $line =~ /^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s/ or next;
        next if $1 eq "UNIT";
        $res->{$1} = { load => $2, state => $3, substate => $4 };
    }
    return $res;
}

# Forget about previously failed services.
system("@systemd@/bin/systemctl", "reset-failed");

# Stop all services that no longer exist or have changed in the new
# configuration.
my @unitsToStop;
my $active = getActiveUnits;
while (my ($unit, $state) = each %{$active}) {
    my $state = $active->{$unit};
    my $baseUnit = $unit;
    # Recognise template instances.
    $baseUnit = "$1\@.$2" if $unit =~ /^(.*)@[^\.]*\.(.*)$/;
    my $curUnitFile = "/etc/systemd/system/$baseUnit";
    if (-e $curUnitFile && ($state->{state} eq "active" || $state->{state} eq "activating")) {
        my $newUnitFile = "@out@/etc/systemd/system/$baseUnit";
        if (! -e $newUnitFile) {
            push @unitsToStop, $unit;
        } elsif (abs_path($curUnitFile) ne abs_path($newUnitFile)) {
            # Record that this unit needs to be started below.  We
            # write this to a file to ensure that the service gets
            # restarted if we're interrupted.
            write_file($restartListFile, { append => 1 }, "$unit\n");
            push @unitsToStop, $unit;
        }
    }
}

print STDERR "stopping the following units: ", join(", ", sort(@unitsToStop)), "\n";
system("@systemd@/bin/systemctl", "stop", @unitsToStop)
    if scalar @unitsToStop > 0; # FIXME: ignore errors?

# Activate the new configuration (i.e., update /etc, make accounts,
# and so on).
my $res = 0;
print STDERR "activating the configuration...\n";
system("@out@/activate", "@out@") == 0 or $res = 2;

# FIXME: Re-exec systemd if necessary.

# Make systemd reload its units.
system("@systemd@/bin/systemctl", "daemon-reload") == 0 or $res = 3;

# Start all units required by the default target.  This should start
# most changed units we stopped above as well as any new dependencies.
print STDERR "starting default target...\n";
system("@systemd@/bin/systemctl", "start", "default.target") == 0 or $res = 4;

# Start changed units we stopped above.  This is necessary because
# some may not be dependencies of the default target (i.e., they were
# manually started).
my @stopped = split '\n', read_file($restartListFile, err_mode => 'quiet') // "";
if (scalar @stopped > 0) {
    my %unique = map { $_, 1 } @stopped;
    my @unique = sort(keys(%unique));
    print STDERR "restarting the following units: ", join(", ", @unique), "\n";
    system("@systemd@/bin/systemctl", "start", @unique) == 0 or $res = 4;
    unlink($restartListFile);
}

# Signal dbus to reload its configuration.
system("@systemd@/bin/systemctl", "reload", "dbus.service");

# Check all the failed services.
$active = getActiveUnits;
my @failed;
while (my ($unit, $state) = each %{$active}) {
    push @failed, $unit if $state->{state} eq "failed";
}
if (scalar @failed > 0) {
    print STDERR "warning: the following units failed: ", join(", ", sort(@failed)), "\n";
    foreach my $unit (@failed) {
        print STDERR "\n";
        system("COLUMNS=1000 @systemd@/bin/systemctl status --no-pager '$unit' >&2");
    }
    $res = 4;
}

exit $res;
