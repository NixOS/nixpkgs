#! @perl@

use File::Spec;
use File::Path;
use File::Basename;
use File::Slurp;


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


# Process the command line.
my $outDir = "/etc/nixos";

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
    else {
        die "$0: unrecognized argument ‘$arg’\n";
    }
}


my @attrs = ();
my @kernelModules = ();
my @initrdKernelModules = ();
my @modulePackages = ();
my @imports = ("<nixos/modules/installer/scan/not-detected.nix>");


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
    my $vendor = read_file "$path/vendor";
    my $device = read_file "$path/device";
    my $class = read_file "$path/class";

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
            push @initrdKernelModules, $module;
        }
    }

    # broadcom STA driver (wl.ko)
    # list taken from http://www.broadcom.com/docs/linux_sta/README.txt
    if ($vendor eq "0x14e4" &&
        ($device eq "0x4311" || $device eq "0x4312" || $device eq "0x4313" ||
         $device eq "0x4315" || $device eq "0x4327" || $device eq "0x4328" ||
         $device eq "0x4329" || $device eq "0x432a" || $device eq "0x432b" ||
         $device eq "0x432c" || $device eq "0x432d" || $device eq "0x4353" ||
         $device eq "0x4357" || $device eq "0x4358" || $device eq "0x4359" ) )
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
    $videoDriver = "nvidia" if $vendor eq "0x10de" && $class =~ /^0x03/;
}

foreach my $path (glob "/sys/bus/pci/devices/*") {
    pciCheck $path;
}

push @attrs, "services.xserver.videoDrivers = [ \"$videoDriver\" ];" if $videoDriver;


# Idem for USB devices.

sub usbCheck {
    my $path = shift;
    my $class = read_file "$path/bInterfaceClass";
    my $subclass = read_file "$path/bInterfaceSubClass";
    my $protocol = read_file "$path/bInterfaceProtocol";

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
            push @initrdKernelModules, $module;
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
        push @initrdKernelModules, $module;
    }
}


# Check if we're a VirtualBox guest.  If so, enable the guest
# additions.
my $dmi = `@dmidecode@/sbin/dmidecode`;
if ($dmi =~ /Manufacturer: innotek/) {
    push @attrs, "services.virtualbox.enable = true;"
}


# Generate the swapDevices option from the currently activated swap
# devices.
my @swaps = read_file("/proc/swaps");
shift @swaps;
my @swapDevices;
foreach my $swap (@swaps) {
    $swap =~ /^(\S+)\s/;
    push @swapDevices, "{ device = \"$1\"; }";
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

    # Skip special filesystems.
    next if in($mountPoint, "/proc") || in($mountPoint, "/dev") || in($mountPoint, "/sys") || in($mountPoint, "/run");

    # Skip the optional fields.
    my $n = 6; $n++ while $fields[$n] ne "-"; $n++;
    my $fsType = $fields[$n];
    my $device = $fields[$n + 1];
    my @superOptions = split /,/, $fields[$n + 2];

    # Skip the read-only bind-mount on /nix/store.
    next if $mountPoint eq "/nix/store" && (grep { $_ eq "rw" } @superOptions) && (grep { $_ eq "ro" } @mountOptions);

    # Maybe this is a bind-mount of a filesystem we saw earlier?
    if (defined $fsByDev{$fields[2]}) {
        my $path = $fields[3]; $path = "" if $path eq "/";
        $fileSystems .= <<EOF;
  fileSystems.\"$mountPoint\" =
    { device = \"$fsByDev{$fields[2]}$path\";
      fsType = \"none\";
      options = \"bind\";
    };

EOF
        next;
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

    # Emit the filesystem.
    $fileSystems .= <<EOF;
  fileSystems.\"$mountPoint\" =
    { device = \"$device\";
      fsType = \"$fsType\";
      options = \"${\join ",", uniq(@extraOptions, @superOptions, @mountOptions)}\";
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
    return "[ ]" if !@_;
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

my $initrdKernelModules = toNixExpr(uniq @initrdKernelModules);
my $kernelModules = toNixExpr(uniq @kernelModules);
my $modulePackages = toNixExpr(uniq @modulePackages);

my $fn = "$outDir/hardware-configuration.nix";
print STDERR "writing $fn...\n";
mkpath($outDir, 0, 0755);

write_file($fn, <<EOF);
# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, pkgs, ... }:

{
  imports = ${\multiLineList("    ", @imports)};

  boot.initrd.kernelModules = [$initrdKernelModules ];
  boot.kernelModules = [$kernelModules ];
  boot.extraModulePackages = [$modulePackages ];

${fileSystems}  swapDevices = ${\multiLineList("    ", @swapDevices)};

  nix.maxJobs = $cpus;
${\join "", (map { "  $_\n" } (uniq @attrs))}}
EOF


# Generate a basic configuration.nix, unless one already exists.
$fn = "$outDir/configuration.nix";
if (! -e $fn) {
    print STDERR "writing $fn...\n";

    my $bootloaderConfig;
    if (-e "/sys/firmware/efi/efivars") {
        $bootLoaderConfig = <<EOF;
  # Use the gummiboot efi boot loader.
  boot.loader.grub.enable = false;
  boot.loader.gummiboot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # !!! Remove this when nixos is on 3.10 or greater by default
  # EFI booting requires kernel >= 3.10
  boot.kernelPackages = pkgs.linuxPackages_3_10;
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

  boot.initrd.kernelModules =
    [ # Specify all kernel modules that are necessary for mounting the root
      # filesystem.
      # "xfs" "ata_piix"
      # fbcon # Uncomment this when EFI booting to see the console before the root partition is mounted
    ];

$bootLoaderConfig
  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless.

  # Add filesystem entries for each partition that you want to see
  # mounted at boot time.  This should include at least the root
  # filesystem.

  # fileSystems."/".device = "/dev/disk/by-label/nixos";

  # fileSystems."/data" =     # where you want to mount the device
  #   { device = "/dev/sdb";  # the device
  #     fsType = "ext3";      # the type of the partition
  #     options = "data=journal";
  #   };

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "lat9w-16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

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
}
EOF
} else {
    print STDERR "warning: not overwriting existing $fn\n";
}

# workaround for a bug in substituteAll
