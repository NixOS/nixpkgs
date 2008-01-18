#! @shell@ -e


kernelModules=
initrdKernelModules=

hasCPUFeature() {
    local feature="$1"
    cat /proc/cpuinfo | grep -q "^flags.* $feature\( \|$\)"
}

needKernelModule() {
    kernelModules="$kernelModules \"$1\""
}

needInitrdKernelModule() {
    initrdKernelModules="$initrdKernelModules \"$1\""
}


# Detect the number of CPU cores.
cpus="$(cat /proc/cpuinfo | grep '^processor' | wc -l)"


# CPU frequency scaling.  Not sure about this test.
if hasCPUFeature "acpi"; then
    needKernelModule "acpi-cpufreq"
fi


# Virtualization support?
if hasCPUFeature "vmx"; then
    needKernelModule "kvm-intel"
fi

if hasCPUFeature "svm"; then
    needKernelModule "kvm-amd"
fi


# Look at the PCI devices and add necessary modules.  Note that most
# modules are auto-detected so we don't need to list them here.
# However, some are needed in the initrd to boot the system.

pciCheck() {
    local path="$1"
    local vendor="$(cat $path/vendor)" 
    local device="$(cat $path/device)"
    local class="$(cat $path/class)"

    local module
    if test -e "$path/driver/module"; then
        module=$(basename $(readlink -f $path/driver/module))
    fi

    echo "$path: $vendor $device $class $module"

    if test -n "$module"; then
        # See the bottom of http://pciids.sourceforge.net/pci.ids for
        # device classes.
        case $class in
            0x01*)
                # Mass-storage controller.  Definitely important.
                needInitrdKernelModule $module
                ;;
            0x0c00*)
                # Firewire controller.  A disk might be attached.
                needInitrdKernelModule $module
                ;;
            0x0c03*)
                # USB controller.  Needed if we want to use the
                # keyboard when things go wrong in the initrd.
                needInitrdKernelModule $module
                ;;
        esac
    fi        
}

for path in /sys/bus/pci/devices/*; do
    pciCheck "$path"
done


# Idem for USB devices.

usbCheck() {
    local path="$1"
    local class="$(cat $path/bInterfaceClass)" 
    local subclass="$(cat $path/bInterfaceSubClass)"
    local protocol="$(cat $path/bInterfaceProtocol)"

    local module
    if test -e "$path/driver/module"; then
        module=$(basename $(readlink -f $path/driver/module))
    fi

    echo "$path: $class $subclass $protocol $module"

    if test -n "$module"; then
        # See http://www.linux-usb.org/usb.ids for
        # classes/subclasses/protocols.
        case $class:$subclass:$protocol in
            08:*)
                # Mass-storage controller.  Definitely important.
                needInitrdKernelModule $module
                ;;
            03:*:01)
                # Keyboard.  Needed if we want to use the
                # keyboard when things go wrong in the initrd.
                needInitrdKernelModule $module
                ;;
        esac
    fi        
}

for path in /sys/bus/usb/devices/*; do
    if test -e "$path/bInterfaceClass"; then
        usbCheck "$path"
    fi
done


# Remove duplicate modules.  !!! preserve order
kernelModules=$(for i in $kernelModules; do echo $i; done | sort | uniq)
initrdKernelModules=$(for i in $initrdKernelModules; do echo $i; done | sort | uniq)


# Generation the configuration file.
cat <<EOF
# This is a generated file.  Do not modify!
# Make changes to /etc/nixos/configuration.nix instead.
{
  boot = {
    initrd = {
      extraKernelModules = [ $(echo $initrdKernelModules) ];
    };
    kernelModules = [ $(echo $kernelModules) ];
  };

  nix = {
    maxJobs = $cpus;
  };
}
EOF
