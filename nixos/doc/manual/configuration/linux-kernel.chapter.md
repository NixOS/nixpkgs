# Linux Kernel {#sec-kernel-config}

You can override the Linux kernel and associated packages using the
option `boot.kernelPackages`. For instance, this selects the Linux 3.10
kernel:

```nix
boot.kernelPackages = pkgs.linuxKernel.packages.linux_3_10;
```

Note that this not only replaces the kernel, but also packages that are
specific to the kernel version, such as the NVIDIA video drivers. This
ensures that driver packages are consistent with the kernel.

While `pkgs.linuxKernel.packages` contains all available kernel packages,
you may want to use one of the unversioned `pkgs.linuxPackages_*` aliases
such as `pkgs.linuxPackages_latest`, that are kept up to date with new
versions.

Please note that the current convention in NixOS is to only keep actively
maintained kernel versions on both unstable and the currently supported stable
release(s) of NixOS. This means that a non-longterm kernel will be removed after it's
abandoned by the kernel developers, even on stable NixOS versions. If you
pin your kernel onto a non-longterm version, expect your evaluation to fail as
soon as the version is out of maintenance.

Longterm versions of kernels will be removed before the next stable NixOS that will
exceed the maintenance period of the kernel version.

The default Linux kernel configuration should be fine for most users.
You can see the configuration of your current kernel with the following
command:

```ShellSession
zcat /proc/config.gz
```

If you want to change the kernel configuration, you can use the
`packageOverrides` feature (see [](#sec-customising-packages)). For
instance, to enable support for the kernel debugger KGDB:

```nix
nixpkgs.config.packageOverrides = pkgs: pkgs.lib.recursiveUpdate pkgs {
  linuxKernel.kernels.linux_5_10 = pkgs.linuxKernel.kernels.linux_5_10.override {
    extraConfig = ''
      KGDB y
    '';
  };
};
```

`extraConfig` takes a list of Linux kernel configuration options, one
per line. The name of the option should not include the prefix
`CONFIG_`. The option value is typically `y`, `n` or `m` (to build
something as a kernel module).

Kernel modules for hardware devices are generally loaded automatically
by `udev`. You can force a module to be loaded via
[](#opt-boot.kernelModules), e.g.

```nix
boot.kernelModules = [ "fuse" "kvm-intel" "coretemp" ];
```

If the module is required early during the boot (e.g. to mount the root
file system), you can use [](#opt-boot.initrd.kernelModules):

```nix
boot.initrd.kernelModules = [ "cifs" ];
```

This causes the specified modules and their dependencies to be added to
the initial ramdisk.

Kernel runtime parameters can be set through
[](#opt-boot.kernel.sysctl), e.g.

```nix
boot.kernel.sysctl."net.ipv4.tcp_keepalive_time" = 120;
```

sets the kernel's TCP keepalive time to 120 seconds. To see the
available parameters, run `sysctl -a`.

## Building a custom kernel {#sec-linux-config-customizing}

Please refer to the Nixpkgs manual for the various ways of [building a custom kernel](https://nixos.org/nixpkgs/manual#sec-linux-kernel).

To use your custom kernel package in your NixOS configuration, set

```nix
boot.kernelPackages = pkgs.linuxPackagesFor yourCustomKernel;
```

## Developing kernel modules {#sec-linux-config-developing-modules}

This section was moved to the [Nixpkgs manual](https://nixos.org/nixpkgs/manual#sec-linux-kernel-developing-modules).

## ZFS {#sec-linux-zfs}

It's a common issue that the latest stable version of ZFS doesn't support the latest
available Linux kernel. It is recommended to use the latest available LTS that's compatible
with ZFS. Usually this is the default kernel provided by nixpkgs (i.e. `pkgs.linuxPackages`).

Alternatively, it's possible to pin the system to the latest available kernel
version _that is supported by ZFS_ like this:

```nix
{
  boot.kernelPackages = pkgs.zfs.latestCompatibleLinuxPackages;
}
```

Please note that the version this attribute points to isn't monotonic because the latest kernel
version only refers to kernel versions supported by the Linux developers. In other words,
the latest kernel version that ZFS is compatible with may decrease over time.

An example: the latest version ZFS is compatible with is 5.19 which is a non-longterm version. When 5.19
is out of maintenance, the latest supported kernel version is 5.15 because it's longterm and the versions
5.16, 5.17 and 5.18 are already out of maintenance because they're non-longterm.
