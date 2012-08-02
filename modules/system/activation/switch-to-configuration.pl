#! @perl@

use strict;
use warnings;
use File::Slurp;

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
#system("@installBootLoader@ @out@") == 0 or exit 1 if $action eq "switch" || $action eq "boot";
exit 0 if $action eq "boot";

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

# Activate the new configuration (i.e., update /etc, make accounts,
# and so on).
my $res = 0;
print STDERR "activating the configuration...\n";
system("@out@/activate", "@out@") == 0 or $res = 2;

# FIXME: Re-exec systemd if necessary.

# Make systemd reload its units.
system("@systemd@/bin/systemctl", "daemon-reload") == 0 or $res = 3;

# Signal dbus to reload its configuration.
system("@systemd@/bin/systemctl", "reload", "dbus.service");

exit $res;
