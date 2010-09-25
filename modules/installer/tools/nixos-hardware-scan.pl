#! @perl@/bin/perl -w

use File::Spec;
use File::Basename;


my @attrs = ();
my @kernelModules = ();
my @initrdKernelModules = ();


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


# CPU frequency scaling.  Not sure about this test.
push @kernelModules, "acpi-cpufreq" if hasCPUFeature "acpi";


# Virtualization support?
push @kernelModules, "kvm-intel" if hasCPUFeature "vmx";
push @kernelModules, "kvm-amd" if hasCPUFeature "svm";


# Look at the PCI devices and add necessary modules.  Note that most
# modules are auto-detected so we don't need to list them here.
# However, some are needed in the initrd to boot the system.

my $videoDriver = "vesa";

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

    # Hm, can we extract the PCI ids supported by X drivers somehow?
    # cf. http://www.calel.org/pci-devices/xorg-device-list.html
    $videoDriver = "intel" if $vendor eq "0x8086" &&
        ($device eq "0x1132" ||
         $device eq "0x2572" ||
         $device eq "0x2592" ||
         $device eq "0x2772" ||
         $device eq "0x2776" ||
         $device eq "0x2782" ||
         $device eq "0x2792" ||
         $device eq "0x2792" ||
         $device eq "0x27a2" ||
         $device eq "0x27a6" ||
         $device eq "0x29a2" ||
         $device eq "0x3582" ||
         $device eq "0x7121" ||
         $device eq "0x7123" ||
         $device eq "0x7125" ||
         $device eq "0x7128"
        );

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


# Generate the configuration file.

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
    foreach my $s (@_) {
        $res .= "\n$indent$s";
    }
    $res .= "\n$indent";
    return $res;
}

my $initrdKernelModules = toNixExpr(removeDups @initrdKernelModules);
my $kernelModules = toNixExpr(removeDups @kernelModules);
my $attrs = multiLineList("  ", removeDups @attrs);

print <<EOF ;
# This is a generated file.  Do not modify!
# Make changes to /etc/nixos/configuration.nix instead.
{modulesPath, ...}:

{
  require = [
    "\${modulesPath}/installer/scan/not-detected.nix"
  ];

  boot.initrd.kernelModules = [ $initrdKernelModules ];
  boot.kernelModules = [ $kernelModules ];

  nix.maxJobs = $cpus;

  services.xserver.videoDriver = "$videoDriver";
  $attrs
}
EOF
