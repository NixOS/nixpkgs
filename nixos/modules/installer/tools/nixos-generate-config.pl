#! @perl@

use Cwd 'abs_path';
use File::Spec;
use File::Path;
use File::Basename;
use File::Slurp;
use File::stat;


sub uniq {
    my %seen;
    my @res = ();
    foreach my $s (@_) {
        if (!defined $seen{$s}) {
            $seen{$s} = 1;
            push @res, $s;
        }
    }
    return @res;
}

sub runCommand {
    my ($cmd) = @_;
    open FILE, "$cmd 2>&1 |" or die "Failed to execute: $cmd\n";
    my @ret = <FILE>;
    close FILE;
    return ($?, @ret);
}

# Process the command line.
my $outDir = "/etc/nixos";
my $rootDir = ""; # = /
my $force = 0;
my $noFilesystems = 0;
my $showHardwareConfig = 0;

for (my $n = 0; $n < scalar @ARGV; $n++) {
    my $arg = $ARGV[$n];
    if ($arg eq "--help") {
        exec "man nixos-generate-config" or die;
    }
    elsif ($arg eq "--dir") {
        $n++;
        $outDir = $ARGV[$n];
        die "$0: ‘--dir’ requires an argument\n" unless defined $outDir;
    }
    elsif ($arg eq "--root") {
        $n++;
        $rootDir = $ARGV[$n];
        die "$0: ‘--root’ requires an argument\n" unless defined $rootDir;
        $rootDir =~ s/\/*$//; # remove trailing slashes
    }
    elsif ($arg eq "--force") {
        $force = 1;
    }
    elsif ($arg eq "--no-filesystems") {
        $noFilesystems = 1;
    }
    elsif ($arg eq "--show-hardware-config") {
        $showHardwareConfig = 1;
    }
    else {
        die "$0: unrecognized argument ‘$arg’\n";
    }
}


my @attrs = ();
my @kernelModules = ();
my @initrdKernelModules = ();
my @modulePackages = ();
my @imports = ("<nixpkgs/nixos/modules/installer/scan/not-detected.nix>");


sub debug {
    return unless defined $ENV{"DEBUG"};
    print STDERR @_;
}


my $cpuinfo = read_file "/proc/cpuinfo";


sub hasCPUFeature {
    my $feature = shift;
    return $cpuinfo =~ /^flags\s*:.* $feature( |$)/m;
}


# Detect the number of CPU cores.
my $cpus = scalar (grep {/^processor\s*:/} (split '\n', $cpuinfo));


# Virtualization support?
push @kernelModules, "kvm-intel" if hasCPUFeature "vmx";
push @kernelModules, "kvm-amd" if hasCPUFeature "svm";


# Look at the PCI devices and add necessary modules.  Note that most
# modules are auto-detected so we don't need to list them here.
# However, some are needed in the initrd to boot the system.

my $videoDriver;

sub pciCheck {
    my $path = shift;
    my $vendor = read_file "$path/vendor"; chomp $vendor;
    my $device = read_file "$path/device"; chomp $device;
    my $class = read_file "$path/class"; chomp $class;

    my $module;
    if (-e "$path/driver/module") {
        $module = basename `readlink -f $path/driver/module`;
        chomp $module;
    }

    debug "$path: $vendor $device $class";
    debug " $module" if defined $module;
    debug "\n";

    if (defined $module) {
        # See the bottom of http://pciids.sourceforge.net/pci.ids for
        # device classes.
        if (# Mass-storage controller.  Definitely important.
            $class =~ /^0x01/ ||

            # Firewire controller.  A disk might be attached.
            $class =~ /^0x0c00/ ||

            # USB controller.  Needed if we want to use the
            # keyboard when things go wrong in the initrd.
            $class =~ /^0x0c03/
            )
        {
            push @initrdAvailableKernelModules, $module;
        }
    }

    # broadcom STA driver (wl.ko)
    # list taken from http://www.broadcom.com/docs/linux_sta/README.txt
    if ($vendor eq "0x14e4" &&
        ($device eq "0x4311" || $device eq "0x4312" || $device eq "0x4313" ||
         $device eq "0x4315" || $device eq "0x4327" || $device eq "0x4328" ||
         $device eq "0x4329" || $device eq "0x432a" || $device eq "0x432b" ||
         $device eq "0x432c" || $device eq "0x432d" || $device eq "0x4353" ||
         $device eq "0x4357" || $device eq "0x4358" || $device eq "0x4359" ||
         $device eq "0x4331" || $device eq "0x43a0" || $device eq "0x43b1"
        ) )
     {
        push @modulePackages, "config.boot.kernelPackages.broadcom_sta";
        push @kernelModules, "wl";
     }

    # Can't rely on $module here, since the module may not be loaded
    # due to missing firmware.  Ideally we would check modules.pcimap
    # here.
    push @attrs, "networking.enableIntel2200BGFirmware = true;" if
        $vendor eq "0x8086" &&
        ($device eq "0x1043" || $device eq "0x104f" || $device eq "0x4220" ||
         $device eq "0x4221" || $device eq "0x4223" || $device eq "0x4224");

    push @attrs, "networking.enableIntel3945ABGFirmware = true;" if
        $vendor eq "0x8086" &&
        ($device eq "0x4229" || $device eq "0x4230" ||
         $device eq "0x4222" || $device eq "0x4227");

    # Assume that all NVIDIA cards are supported by the NVIDIA driver.
    # There may be exceptions (e.g. old cards).
    # FIXME: do we want to enable an unfree driver here?
    #$videoDriver = "nvidia" if $vendor eq "0x10de" && $class =~ /^0x03/;
}

foreach my $path (glob "/sys/bus/pci/devices/*") {
    pciCheck $path;
}

push @attrs, "services.xserver.videoDrivers = [ \"$videoDriver\" ];" if $videoDriver;


# Idem for USB devices.

sub usbCheck {
    my $path = shift;
    my $class = read_file "$path/bInterfaceClass"; chomp $class;
    my $subclass = read_file "$path/bInterfaceSubClass"; chomp $subclass;
    my $protocol = read_file "$path/bInterfaceProtocol"; chomp $protocol;

    my $module;
    if (-e "$path/driver/module") {
        $module = basename `readlink -f $path/driver/module`;
        chomp $module;
    }

    debug "$path: $class $subclass $protocol";
    debug " $module" if defined $module;
    debug "\n";

    if (defined $module) {
        if (# Mass-storage controller.  Definitely important.
            $class eq "08" ||

            # Keyboard.  Needed if we want to use the
            # keyboard when things go wrong in the initrd.
            ($class eq "03" && $protocol eq "01")
            )
        {
            push @initrdAvailableKernelModules, $module;
        }
    }
}

foreach my $path (glob "/sys/bus/usb/devices/*") {
    if (-e "$path/bInterfaceClass") {
        usbCheck $path;
    }
}


# Add the modules for all block devices.
foreach my $path (glob "/sys/class/block/*") {
    my $module;
    if (-e "$path/device/driver/module") {
        $module = basename `readlink -f $path/device/driver/module`;
        chomp $module;
        push @initrdAvailableKernelModules, $module;
    }
}


my $virt = `systemd-detect-virt`;
chomp $virt;


# Check if we're a VirtualBox guest.  If so, enable the guest
# additions.
if ($virt eq "oracle") {
    push @attrs, "services.virtualbox.enable = true;"
}


# Likewise for QEMU.
if ($virt eq "qemu" || $virt eq "kvm" || $virt eq "bochs") {
    push @imports, "<nixpkgs/nixos/modules/profiles/qemu-guest.nix>";
}


# For a device name like /dev/sda1, find a more stable path like
# /dev/disk/by-uuid/X or /dev/disk/by-label/Y.
sub findStableDevPath {
    my ($dev) = @_;
    return $dev if substr($dev, 0, 1) ne "/";
    return $dev unless -e $dev;

    my $st = stat($dev) or return $dev;

    foreach my $dev2 (glob("/dev/disk/by-uuid/*"), glob("/dev/mapper/*"), glob("/dev/disk/by-label/*")) {
        my $st2 = stat($dev2) or next;
        return $dev2 if $st->rdev == $st2->rdev;
    }

    return $dev;
}


# Generate the swapDevices option from the currently activated swap
# devices.
my @swaps = read_file("/proc/swaps");
shift @swaps;
my @swapDevices;
foreach my $swap (@swaps) {
    $swap =~ /^(\S+)\s/;
    next unless -e $1;
    my $dev = findStableDevPath $1;
    push @swapDevices, "{ device = \"$dev\"; }";
}


# Generate the fileSystems option from the currently mounted
# filesystems.
sub in {
    my ($d1, $d2) = @_;
    return $d1 eq $d2 || substr($d1, 0, length($d2) + 1) eq "$d2/";
}

my $fileSystems;
my %fsByDev;
foreach my $fs (read_file("/proc/self/mountinfo")) {
    chomp $fs;
    my @fields = split / /, $fs;
    my $mountPoint = $fields[4];
    next unless -d $mountPoint;
    my @mountOptions = split /,/, $fields[5];

    next if !in($mountPoint, $rootDir);
    $mountPoint = substr($mountPoint, length($rootDir)); # strip the root directory (e.g. /mnt)
    $mountPoint = "/" if $mountPoint eq "";

    # Skip special filesystems.
    next if in($mountPoint, "/proc") || in($mountPoint, "/dev") || in($mountPoint, "/sys") || in($mountPoint, "/run") || $mountPoint eq "/var/lib/nfs/rpc_pipefs";
    next if $mountPoint eq "/var/setuid-wrappers";

    # Skip the optional fields.
    my $n = 6; $n++ while $fields[$n] ne "-"; $n++;
    my $fsType = $fields[$n];
    my $device = $fields[$n + 1];
    my @superOptions = split /,/, $fields[$n + 2];

    # Skip the read-only bind-mount on /nix/store.
    next if $mountPoint eq "/nix/store" && (grep { $_ eq "rw" } @superOptions) && (grep { $_ eq "ro" } @mountOptions);

    # Maybe this is a bind-mount of a filesystem we saw earlier?
    if (defined $fsByDev{$fields[2]}) {
        # Make sure this isn't a btrfs subvolume
        my ($status, @msg) = runCommand("btrfs subvol show $rootDir$mountPoint");
        if (join("", @msg) =~ /ERROR:/) {
            my $path = $fields[3]; $path = "" if $path eq "/";
            my $base = $fsByDev{$fields[2]};
            $base = "" if $base eq "/";
            $fileSystems .= <<EOF;
  fileSystems.\"$mountPoint\" =
    { device = \"$base$path\";
      fsType = \"none\";
      options = \"bind\";
    };

EOF
            next;
        }
    }
    $fsByDev{$fields[2]} = $mountPoint;

    # We don't know how to handle FUSE filesystems.
    if ($fsType eq "fuseblk" || $fsType eq "fuse") {
        print STDERR "warning: don't know how to emit ‘fileSystem’ option for FUSE filesystem ‘$mountPoint’\n";
        next;
    }

    # Is this a mount of a loopback device?
    my @extraOptions;
    if ($device =~ /\/dev\/loop(\d+)/) {
        my $loopnr = $1;
        my $backer = read_file "/sys/block/loop$loopnr/loop/backing_file";
        if (defined $backer) {
            chomp $backer;
            $device = $backer;
            push @extraOptions, "loop";
        }
    }

    # Is this a btrfs filesystem?
    if ($fsType eq "btrfs") {
        my ($status, @id_info) = runCommand("btrfs subvol show $rootDir$mountPoint");
        if ($status != 0 || join("", @msg) =~ /ERROR:/) {
            die "Failed to retreive subvolume info for $mountPoint\n";
        }
        my @ids = join("", @id_info) =~ m/Object ID:[ \t\n]*([^ \t\n]*)/;
        if ($#ids > 0) {
            die "Btrfs subvol name for $mountPoint listed multiple times in mount\n"
        } elsif ($#ids == 0) {
            my ($status, @path_info) = runCommand("btrfs subvol list $rootDir$mountPoint");
            if ($status != 0) {
                die "Failed to find $mountPoint subvolume id from btrfs\n";
            }
            my @paths = join("", @path_info) =~ m/ID $ids[0] [^\n]* path ([^\n]*)/;
            if ($#paths > 0) {
                die "Btrfs returned multiple paths for a single subvolume id, mountpoint $mountPoint\n";
            } elsif ($#paths != 0) {
                die "Btrfs did not return a path for the subvolume at $mountPoint\n";
            }
            push @extraOptions, "subvol=$paths[0]";
        }
    }

    # Emit the filesystem.
    $fileSystems .= <<EOF;
  fileSystems.\"$mountPoint\" =
    { device = \"${\(findStableDevPath $device)}\";
      fsType = \"$fsType\";
EOF

    if (scalar @extraOptions > 0) {
      $fileSystems .= <<EOF;
      options = \"${\join ",", uniq(@extraOptions)}\";
EOF
    }

    $fileSystems .= <<EOF;
    };

EOF
}


# Generate the hardware configuration file.

sub toNixExpr {
    my $res = "";
    foreach my $s (@_) {
        $res .= " \"$s\"";
    }
    return $res;
}

sub multiLineList {
    my $indent = shift;
    return " [ ]" if !@_;
    $res = "\n${indent}[ ";
    my $first = 1;
    foreach my $s (@_) {
        $res .= "$indent  " if !$first;
        $first = 0;
        $res .= "$s\n";
    }
    $res .= "$indent]";
    return $res;
}

my $initrdAvailableKernelModules = toNixExpr(uniq @initrdAvailableKernelModules);
my $kernelModules = toNixExpr(uniq @kernelModules);
my $modulePackages = toNixExpr(uniq @modulePackages);

my $fsAndSwap = "";
if (!$noFilesystems) {
    $fsAndSwap = "\n${fileSystems}  ";
    $fsAndSwap .= "swapDevices =" . multiLineList("    ", @swapDevices) . ";\n";
}

my $hwConfig = <<EOF;
# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, pkgs, ... }:

{
  imports =${\multiLineList("    ", @imports)};

  boot.initrd.availableKernelModules = [$initrdAvailableKernelModules ];
  boot.kernelModules = [$kernelModules ];
  boot.extraModulePackages = [$modulePackages ];
$fsAndSwap
  nix.maxJobs = $cpus;
${\join "", (map { "  $_\n" } (uniq @attrs))}}
EOF


if ($showHardwareConfig) {
    print STDOUT $hwConfig;
} else {
    $outDir = "$rootDir$outDir";

    my $fn = "$outDir/hardware-configuration.nix";
    print STDERR "writing $fn...\n";
    mkpath($outDir, 0, 0755);
    write_file($fn, $hwConfig);

    # Generate a basic configuration.nix, unless one already exists.
    $fn = "$outDir/configuration.nix";
    if ($force || ! -e $fn) {
        print STDERR "writing $fn...\n";

        my $bootloaderConfig;
        if (-e "/sys/firmware/efi/efivars") {
            $bootLoaderConfig = <<EOF;
  # Use the gummiboot efi boot loader.
  boot.loader.gummiboot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
EOF
        } else {
            $bootLoaderConfig = <<EOF;
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda";
EOF
        }

        write_file($fn, <<EOF);
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

$bootLoaderConfig
  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless.

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "lat9w-16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # List packages installed in system profile. To search by name, run:
  # \$ nix-env -qaP | grep wget
  # environment.systemPackages = with pkgs; [
  #   wget
  # ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.kde4.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   name = "guest";
  #   group = "users";
  #   uid = 1000;
  #   createHome = true;
  #   home = "/home/guest";
  #   shell = "/run/current-system/sw/bin/bash";
  # };

}
EOF
    } else {
        print STDERR "warning: not overwriting existing $fn\n";
    }
}

# workaround for a bug in substituteAll
