#! @perl@

use strict;
use warnings;
use Hash::Diff qw( left_diff );
use Hash::Merge qw( merge );
use File::Basename;
use File::Slurp;
use File::Path qw( make_path );
use Net::DBus;
use Sys::Syslog qw(:standard :macros);
use Cwd 'abs_path';
use Data::Dumper;

my $out = "@out@";
my $action = shift @ARGV;

if ( "@localeArchive@" ne "" ) {
    $ENV{LOCALE_ARCHIVE} = "@localeArchive@";
}

if ( !defined $action || ($action ne "switch" && $action ne "boot" && $action ne "test" && $action ne "dry-activate") ) {
    print STDERR <<EOF;
Usage: $0 [switch|boot|test]

switch:       make the configuration the boot default and activate now
boot:         make the configuration the boot default
test:         activate the configuration, but don\'t make it the boot default
dry-activate: show what would be done if this configuration were activated
EOF
    exit 1;
}

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
    exit 100 unless $action eq "dry-activate";
}

# Ignore SIGHUP so that we're not killed if we're running on (say)
# virtual console 1 and we restart the "tty1" unit.
$SIG{PIPE} = "IGNORE";

sub resolve_link {
    my $path = shift @_;

    while ( my $next = readlink $path ) {
        $path = $next;
    }

    return $path;
}

my %currentUnits = map { $_ => resolve_link "/run/current-services/$_" } (read_dir("/run/current-services"));
my %nextUnits = map { $_ => resolve_link "$out/etc/sv/$_" } (read_dir("@out@/etc/sv"));

my %removedUnits = %{ left_diff( \%currentUnits, \%nextUnits ) };
my %newUnits = %{ left_diff( \%nextUnits, \%currentUnits ) };

my (%unitsToStop, %unitsToStart, %unitsToDelete, %runningUnits, %stoppedUnits, %changedUnits);

my $unit;

# All units that are in both removedUnits and newUnits are actually changed
foreach $unit (keys %newUnits) {
    if ( exists $removedUnits{$unit} ) {
        $changedUnits{$unit} = $newUnits{$unit};
        delete $removedUnits{$unit};
        delete $newUnits{$unit};
    }
}

# Check which services are running

foreach $unit (keys %currentUnits)
{
    my $status = `sv status /run/current-services/$unit`;

    if ( $status =~ /^run:/ ) {
        $runningUnits{$unit} = 1;
    } else {
        $stoppedUnits{$unit} = 1;
    }
}

# We need to stop all units that are running and that are being
# removed or are being changed
foreach $unit ( keys %runningUnits )
{
    if ( exists $removedUnits{$unit} ||
         exists $changedUnits{$unit} ) {
        $unitsToStop{$unit} = 1;
    }
}

# We need to start all units that are new or all units that are
# changed and that were running before
foreach $unit ( keys %newUnits ) {
    $unitsToStart{$unit} = 1;
}
foreach $unit ( keys %changedUnits ) {
    if ( exists $runningUnits{$unit} ) {
        $unitsToStart{$unit} = 1;
    }
}

# We need to link all units that are changed

# We need to delete all units that were removed
my (@old_topo_sort, @new_topo_sort);

if ( -e "/etc/runit-sv-sorted" ) {
    @old_topo_sort = read_file("/etc/runit-sv-sorted", err_mode => 'quiet', chomp => 1);
} else {
    @old_topo_sort = keys %{ merge( \%currentUnits, \%newUnits ) };
}

@new_topo_sort = read_file("$out/etc/runit-sv-sorted", err_mode => 'quiet', chomp => 1);

my @orderedUnitsToStop = grep {exists $unitsToStop{$_}} (reverse @old_topo_sort);
my @orderedUnitsToStart = grep {exists $unitsToStart{$_}} @new_topo_sort;
my @orderedUnitsToLink = grep {exists $changedUnits{$_} || exists $newUnits{$_}} @new_topo_sort;

# If the action is just to dry-activate, then print out what we would do

my $totalActions = scalar @orderedUnitsToStop + scalar @orderedUnitsToStart + scalar @orderedUnitsToLink;

if ( $totalActions == 0 ) {
    print "No changes\n";
} else {
    foreach $unit (@orderedUnitsToStop) {
        print "Stop $unit\n";

        if ( $action ne "dry-activate" ) {
            system("sv stop /run/current-services/$unit") == 0 or exit 1;
        }
    }

    foreach $unit (@orderedUnitsToLink) {
        my $target = $changedUnits{$unit} // $newUnits{$unit};
        print "Link $target to /run/current-services/$unit\n";

        if ( $action ne "dry-activate" ) {
            unlink "/run/current-services/$unit" or exit 1;
            symlink($target, "/run/current-services/$unit") or exit 1;

            # Attempt to create
            make_path("/var/run/runit/sv.$unit");

            if ( -e "/run/current-services/$unit/log" ) {
                make_path("/var/run/runit/sv.log.$unit");
            }
        }
    }

    foreach $unit (keys %removedUnits) {
        print "Removing old service $unit";
        unlink "/run/current-services/$unit" or exit 1;
    }

    foreach $unit (@orderedUnitsToStart) {
        print "Start $unit\n";

        if ( $action ne "dry-activate" ) {
            system("sv start /run/current-services/$unit") # Do not fail on failed services
        }
    }
}

print STDERR "activating the configuration...\n";
system("$out/activate", "$out") == 0 or die "Failed to activate configuration";
