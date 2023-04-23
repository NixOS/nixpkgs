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

You can customize the default kernel configuration by overriding the arguments for your kernel package:

```nix
pkgs.linux_latest.override {
  ignoreConfigErrors = true;
  autoModules = false;
  kernelPreferBuiltin = true;
  extraStructuredConfig = with lib.kernel; {
    DEBUG_KERNEL = yes;
    FRAME_POINTER = yes;
    KGDB = yes;
    KGDB_SERIAL_CONSOLE = yes;
    DEBUG_INFO = yes;
  };
}
```

See `pkgs/os-specific/linux/kernel/generic.nix` for details on how these arguments
affect the generated configuration. You can also build a custom version of Linux by calling
`pkgs.buildLinux` directly, which requires the `src` and `version` arguments to be specified.

To use your custom kernel package in your NixOS configuration, set

```nix
boot.kernelPackages = pkgs.linuxPackagesFor yourCustomKernel;
```

Note that this method will use the common configuration defined in `pkgs/os-specific/linux/kernel/common-config.nix`,
which is suitable for a NixOS system.

If you already have a generated configuration file, you can build a kernel that uses it with `pkgs.linuxManualConfig`:

```nix
let
  baseKernel = pkgs.linux_latest;
in pkgs.linuxManualConfig {
  inherit (baseKernel) src modDirVersion;
  version = "${baseKernel.version}-custom";
  configfile = ./my_kernel_config;
  allowImportFromDerivation = true;
}
```

::: {.note}
The build will fail if `modDirVersion` does not match the source's `kernel.release` file,
so `modDirVersion` should remain tied to `src`.
:::

To edit the `.config` file for Linux X.Y, proceed as follows:

```ShellSession
$ nix-shell '<nixpkgs>' -A linuxKernel.kernels.linux_X_Y.configEnv
$ unpackPhase
$ cd linux-*
$ make nconfig
```

## Developing kernel modules {#sec-linux-config-developing-modules}

When developing kernel modules it's often convenient to run
edit-compile-run loop as quickly as possible. See below snippet as an
example of developing `mellanox` drivers.

```ShellSession
$ nix-build '<nixpkgs>' -A linuxPackages.kernel.dev
$ nix-shell '<nixpkgs>' -A linuxPackages.kernel
$ unpackPhase
$ cd linux-*
$ make -C $dev/lib/modules/*/build M=$(pwd)/drivers/net/ethernet/mellanox modules
# insmod ./drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko
```

## ZFS {#sec-linux-zfs}

It's a common issue that the latest stable version of ZFS doesn't support the latest
available Linux kernel. It is recommended to use the latest available LTS that's compatible
with ZFS. Usually this is the default kernel provided by nixpkgs (i.e. `pkgs.linuxPackages`).

Alternatively, it's possible to pin the system to the latest available kernel
version *that is supported by ZFS* like this:

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
