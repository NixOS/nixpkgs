# Looking Glass {#modules-programs-looking-glass}
[Looking Glass] is an open source application that allows the use of a KVM (Kernel-based Virtual Machine) configured for VGA PCI Pass-through without an attached physical monitor, keyboard or mouse. This is the final step required to move away from dual booting with other operating systems for legacy programs that require high performance graphics.

For details on the installation process being automated through this module, please refer to
the official [Looking Glass installation instructions].

## Basic Usage {#modules-programs-looking-glass-usage}
The module installs the `looking-glass-client` package by default, and has options to configure
the client using the system-wide configuration file. All client options are available as typed
Nix expressions. Additionally, the module provides options to configure the `kvmfr` kernel module
for DMA-assisted frame transfer or the simple Shared Memory file.

```nix
{
  programs.looking-glass = {
    # Install the client package
    enable = true;

    # Install the kvmfr kernel module, and configure it
    # for access from the user named 'caleb'.
    kvmfr = {
      enable = true;
      owner = "caleb";
      sizeMB = 128;
      configureDeviceACLs = true;
    };

    # Setup client settings
    settings = {
      app.shmFile = "/dev/kvmfr0";
      input.escapeKey = "KEY_RIGHTCTRL";
    };
  };
}
```

## KVM Frame Relay (KVMFR) {#modules-programs-looking-glass-kvmfr}
The `kvmfr` kernel module provides DMA-accelerated frame transfer between the guest and host.
Enabling `kvmfr` in this module will add the `kvmfr` module to `boot.extraModulePackages`.
Additionally, the module will configured to load at boot.

In order for `libvirt` to start VMs which use the `kvmfr` device, the device file must be
added to the `cgroup_device_acl` list within `qemu.conf`. If the `kvmfr.configureDeviceACLs`
option is enabled, this module will configure this automatically be adding a block to
`virtualisation.libvirtd.qemu.verbatimConfig`. The option is not enabled by default, but
is likely what you want. However, if you modify `cgroup_device_acl` elsewhere, you should
not enable this option and should instead manually ensure that `/dev/kvmfr0` is added to
the list. If the device is not listed in that option, your VMs will fail to start with
a Permission Denied error.

You should also set the `kvmfr.owner` option to the name of the user which will be using
the Looking Glass client. This module will set the owner of the device file to this user
which enables that user to interact with the device file. If this is not set, you will
not be able to run the client as you will not have read/write access to the device.

## Shared Memory {#modules-programs-looking-glass-shm}
If you choose to use the shared memory file, the only extra configuration you need is
`shm.owner`. This functions similarly to `kvmfr.owner`. The shared memory file will
be owned by the specified user. It should be set to the name of the user who will be
using the Looking Glass client.

[Looking Glass installation instructions]: https://looking-glass.io/docs/B7-rc1/install/
[Looking Glass]: https://looking-glass.io
