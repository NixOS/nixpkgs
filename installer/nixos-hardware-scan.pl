#! @perl@ -w

use File::Spec;
use File::Basename;


my @kernelModules = ();
my @initrdKernelModules = ();


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
    
    print "$path: $vendor $device $class";
    print " $module" if defined $module;
    print "\n";

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
    
    print "$path: $class $subclass $protocol";
    print " $module" if defined $module;
    print "\n";
 
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

my $initrdKernelModules = toNixExpr(removeDups @initrdKernelModules);
my $kernelModules = toNixExpr(removeDups @kernelModules);
 

print <<EOF ;
# This is a generated file.  Do not modify!
# Make changes to /etc/nixos/configuration.nix instead.
{
  boot = {
    initrd = {
      extraKernelModules = [ $initrdKernelModules ];
    };
    kernelModules = [ $kernelModules ];
  };

  nix = {
    maxJobs = $cpus;
  };
}
EOF
