#! @perl@

use strict;
use POSIX;
use File::Path;
use File::Slurp;
use Fcntl ':flock';
use Getopt::Long qw(:config gnu_getopt);

my $socat = '@socat@/bin/socat';

# Ensure a consistent umask.
umask 0022;

# Parse the command line.

sub showHelp {
    print <<EOF;
Usage: nixos-container list
       nixos-container create <container-name> [--config <string>] [--ensure-unique-name]
       nixos-container destroy <container-name>
       nixos-container start <container-name>
       nixos-container stop <container-name>
       nixos-container login <container-name>
       nixos-container root-login <container-name>
       nixos-container run <container-name> -- args...
       nixos-container set-root-password <container-name> <password>
       nixos-container show-ip <container-name>
EOF
    exit 0;
}

my $ensureUniqueName = 0;
my $extraConfig;

GetOptions(
    "help" => sub { showHelp() },
    "ensure-unique-name" => \$ensureUniqueName,
    "config=s" => \$extraConfig
    ) or exit 1;

my $action = $ARGV[0] or die "$0: no action specified\n";


# Execute the selected action.

mkpath("/etc/containers", 0, 0755);
mkpath("/var/lib/containers", 0, 0700);

if ($action eq "list") {
    foreach my $confFile (glob "/etc/containers/*.conf") {
        $confFile =~ /\/([^\/]+).conf$/ or next;
        print "$1\n";
    }
    exit 0;
}

my $containerName = $ARGV[1] or die "$0: no container name specified\n";
$containerName =~ /^[a-zA-Z0-9\-]+$/ or die "$0: invalid container name\n";

sub writeNixOSConfig {
    my ($nixosConfigFile) = @_;

    my $nixosConfig = <<EOF;
{ config, lib, pkgs, ... }:

with lib;

{ boot.isContainer = true;
  networking.hostName = mkDefault "$containerName";
  networking.useDHCP = false;
  $extraConfig
}
EOF

    write_file($nixosConfigFile, $nixosConfig);
}

if ($action eq "create") {
    # Acquire an exclusive lock to prevent races with other
    # invocations of ‘nixos-container create’.
    my $lockFN = "/run/lock/nixos-container";
    open(my $lock, '>>', $lockFN) or die "$0: opening $lockFN: $!";
    flock($lock, LOCK_EX) or die "$0: could not lock $lockFN: $!";

    my $confFile = "/etc/containers/$containerName.conf";
    my $root = "/var/lib/containers/$containerName";

    # Maybe generate a unique name.
    if ($ensureUniqueName) {
        my $base = $containerName;
        for (my $nr = 0; ; $nr++) {
            $containerName = "$base-$nr";
            $confFile = "/etc/containers/$containerName.conf";
            $root = "/var/lib/containers/$containerName";
            last unless -e $confFile || -e $root;
        }
    }

    die "$0: container ‘$containerName’ already exists\n" if -e $confFile;

    # Get an unused IP address.
    my %usedIPs;
    foreach my $confFile2 (glob "/etc/containers/*.conf") {
        my $s = read_file($confFile2) or die;
        $usedIPs{$1} = 1 if $s =~ /^HOST_ADDRESS=([0-9\.]+)$/m;
        $usedIPs{$1} = 1 if $s =~ /^LOCAL_ADDRESS=([0-9\.]+)$/m;
    }

    my ($ipPrefix, $hostAddress, $localAddress);
    for (my $nr = 1; $nr < 255; $nr++) {
        $ipPrefix = "10.233.$nr";
        $hostAddress = "$ipPrefix.1";
        $localAddress = "$ipPrefix.2";
        last unless $usedIPs{$hostAddress} || $usedIPs{$localAddress};
        $ipPrefix = undef;
    }

    die "$0: out of IP addresses\n" unless defined $ipPrefix;

    my @conf;
    push @conf, "PRIVATE_NETWORK=1\n";
    push @conf, "HOST_ADDRESS=$hostAddress\n";
    push @conf, "LOCAL_ADDRESS=$localAddress\n";
    write_file($confFile, \@conf);

    close($lock);

    print STDERR "host IP is $hostAddress, container IP is $localAddress\n";

    mkpath("$root/etc/nixos", 0, 0755);

    my $nixosConfigFile = "$root/etc/nixos/configuration.nix";
    writeNixOSConfig $nixosConfigFile;

    # The per-container directory is restricted to prevent users on
    # the host from messing with guest users who happen to have the
    # same uid.
    my $profileDir = "/nix/var/nix/profiles/per-container";
    mkpath($profileDir, 0, 0700);
    $profileDir = "$profileDir/$containerName";
    mkpath($profileDir, 0, 0755);

    system("nix-env", "-p", "$profileDir/system",
           "-I", "nixos-config=$nixosConfigFile", "-f", "<nixpkgs/nixos>",
           "--set", "-A", "system") == 0
        or die "$0: failed to build initial container configuration\n";

    print "$containerName\n" if $ensureUniqueName;
    exit 0;
}

my $root = "/var/lib/containers/$containerName";
my $profileDir = "/nix/var/nix/profiles/per-container/$containerName";
my $gcRootsDir = "/nix/var/nix/gcroots/per-container/$containerName";
my $confFile = "/etc/containers/$containerName.conf";
if (!-e $confFile) {
    exit 0 if $action eq "destroy";
    die "$0: container ‘$containerName’ does not exist\n" ;
}

sub isContainerRunning {
    my $status = `systemctl show 'container\@$containerName'`;
    return $status =~ /ActiveState=active/;
}

sub stopContainer {
    system("systemctl", "stop", "container\@$containerName") == 0
        or die "$0: failed to stop container\n";
}

if ($action eq "destroy") {
    die "$0: cannot destroy declarative container (remove it from your configuration.nix instead)\n"
        unless POSIX::access($confFile, &POSIX::W_OK);

    stopContainer if isContainerRunning;

    rmtree($profileDir) if -e $profileDir;
    rmtree($gcRootsDir) if -e $gcRootsDir;
    rmtree($root) if -e $root;
    unlink($confFile) or die;
}

elsif ($action eq "start") {
    system("systemctl", "start", "container\@$containerName") == 0
        or die "$0: failed to start container\n";
}

elsif ($action eq "stop") {
    stopContainer;
}

elsif ($action eq "update") {
    my $nixosConfigFile = "$root/etc/nixos/configuration.nix";

    # FIXME: may want to be more careful about clobbering the existing
    # configuration.nix.
    writeNixOSConfig $nixosConfigFile if (defined $extraConfig && $extraConfig ne "");

    system("nix-env", "-p", "$profileDir/system",
           "-I", "nixos-config=$nixosConfigFile", "-f", "<nixpkgs/nixos>",
           "--set", "-A", "system") == 0
        or die "$0: failed to build container configuration\n";

    if (isContainerRunning) {
        print STDERR "reloading container...\n";
        system("systemctl", "reload", "container\@$containerName") == 0
            or die "$0: failed to reload container\n";
    }
}

elsif ($action eq "login") {
    exec("machinectl", "login", "--", $containerName);
}

elsif ($action eq "root-login") {
    exec($socat, "unix:$root/var/lib/root-login.socket", "-,echo=0,raw");
}

elsif ($action eq "run") {
    shift @ARGV; shift @ARGV;
    my $pid = open(SOCAT, "|-", $socat, "-t0", "-", "unix:$root/var/lib/run-command.socket") or die "$0: cannot start $socat: $!\n";
    print SOCAT join(' ', map { "'$_'" } @ARGV), "\n";
    flush SOCAT;
    waitpid($pid, 0);
    close(SOCAT);
}

elsif ($action eq "set-root-password") {
    # FIXME: don't get password from the command line.
    my $password = $ARGV[2] or die "$0: no password given\n";
    my $pid = open(SOCAT, "|-", $socat, "-t0", "-", "unix:$root/var/lib/run-command.socket") or die "$0: cannot start $socat: $!\n";
    print SOCAT "passwd\n";
    print SOCAT "$password\n";
    print SOCAT "$password\n";
    flush SOCAT;
    waitpid($pid, 0);
    close(SOCAT);
}

elsif ($action eq "show-ip") {
    my $s = read_file($confFile) or die;
    $s =~ /^LOCAL_ADDRESS=([0-9\.]+)$/m or die "$0: cannot get IP address\n";
    print "$1\n";
}

else {
    die "$0: unknown action ‘$action’\n";
}
