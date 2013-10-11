#! @perl@

use File::Spec;
use File::Path;
use File::Basename;
use File::Slurp;


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


# Read a file, returning undef if the file cannot be opened.
sub readFile {
    my $filename = shift;
    my $res;
    if (open FILE, "<$filename") {
        my $prev = $/;
        undef $/;
        $res = <FILE>;
        $/ = $prev;
        close FILE;
        chomp $res;
    }
    return $res;
}


my $cpuinfo = readFile "/proc/cpuinfo";


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
    my $vendor = readFile "$path/vendor";
    my $device = readFile "$path/device";
    my $class = readFile "$path/class";

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


# Idem for USB devices.

sub usbCheck {
    my $path = shift;
    my $class = readFile "$path/bInterfaceClass";
    my $subclass = readFile "$path/bInterfaceSubClass";
    my $protocol = readFile "$path/bInterfaceProtocol";

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


if ($videoDriver) {
    push @attrs, "services.xserver.videoDrivers = [ \"$videoDriver\" ];";
}


# Check if we're a VirtualBox guest.  If so, enable the guest
# additions.
my $dmi = `@dmidecode@/sbin/dmidecode`;
if ($dmi =~ /Manufacturer: innotek/) {
    push @attrs, "services.virtualbox.enable = true;"
}


# Generate the hardware configuration file.

sub removeDups {
    my %seen;
    my @res = ();
    foreach my $s (@_) {
        if (!defined $seen{$s}) {
            $seen{$s} = "";
            push @res, $s;
        }
    }
    return @res;
}

sub toNixExpr {
    my $res = "";
    foreach my $s (@_) {
        $res .= " \"$s\"";
    }
    return $res;
}

sub multiLineList {
    my $indent = shift;
    my $res = "";
    $res = "\n" if scalar @_ > 0;
    foreach my $s (@_) {
        $res .= "$indent$s\n";
    }
    return $res;
}

my $initrdKernelModules = toNixExpr(removeDups @initrdKernelModules);
my $kernelModules = toNixExpr(removeDups @kernelModules);
my $modulePackages = toNixExpr(removeDups @modulePackages);
my $attrs = multiLineList("  ", removeDups @attrs);
my $imports = multiLineList("    ", removeDups @imports);

my $fn = "$outDir/hardware.nix";
print STDERR "writing $fn...\n";
mkpath($outDir, 0, 0755);

write_file($fn, <<EOF);
# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, pkgs, ... }:

{
  imports = [$imports  ];

  boot.initrd.kernelModules = [$initrdKernelModules ];
  boot.kernelModules = [$kernelModules ];
  boot.extraModulePackages = [$modulePackages ];

  nix.maxJobs = $cpus;
$attrs}
EOF

# workaround for a bug in substituteAll
