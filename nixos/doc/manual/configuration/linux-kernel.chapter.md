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

## Building a customized kernel {#sec-linux-config-customizing}

You can customize the default kernel configuration by overriding the arguments for your kernel package:

```nix
let
  baseKernel = pkgs.linuxKernel.kernels.linux_5_15;
in baseKernel.override ({
  ignoreConfigErrors = true;
  autoModules = false;
  kernelPreferBuiltin = true;

  extraConfig = ''
    DEBUG_KERNEL y
    FRAME_POINTER y
    KGDB y
    KGDB_SERIAL_CONSOLE y
    DEBUG_INFO y
  '';
});
```

See `pkgs/os-specific/linux/kernel/generic.nix` for details on how these arguments
affect the generated configuration.

If you already have a generated configuration file, you can build a kernel that uses it with `linuxKernel.manualConfig`:

```nix
let
  baseKernel = pkgs.linuxKernel.kernels.linux_5_15;
in pkgs.linuxKernel.manualConfig {
  inherit (pkgs) stdenv hostPlatform;
  inherit (baseKernel) src;
  version = "${baseKernel.version}-custom";

  configfile = /home/me/my_kernel_config;
  allowImportFromDerivation = true;
};
```

Finally, to use your customized kernel package in your NixOS configuration, set

```nix
boot.kernelPackages = pkgs.linuxPackagesFor yourCustomKernel;
```

## Developing kernel modules {#sec-linux-config-developing-modules}

When developing kernel modules it\'s often convenient to run
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
