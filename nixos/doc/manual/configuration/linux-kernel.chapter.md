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

## Customize your kernel {#sec-linux-config-customizing}

The first step before compiling the kernel is to generate an appropriate
`.config` configuration. Either you pass your own config via the
`configfile` setting of `linuxKernel.manualConfig`:

```nix
custom-kernel = let base_kernel = linuxKernel.kernels.linux_4_9;
  in super.linuxKernel.manualConfig {
    inherit (super) stdenv hostPlatform;
    inherit (base_kernel) src;
    version = "${base_kernel.version}-custom";

    configfile = /home/me/my_kernel_config;
    allowImportFromDerivation = true;
};
```

You can edit the config with this snippet (by default `make
   menuconfig` won\'t work out of the box on nixos):

```ShellSession
nix-shell -E 'with import <nixpkgs> {}; kernelToOverride.overrideAttrs (o: {nativeBuildInputs=o.nativeBuildInputs ++ [ pkg-config ncurses ];})'
```

or you can let nixpkgs generate the configuration. Nixpkgs generates it
via answering the interactive kernel utility `make config`. The answers
depend on parameters passed to
`pkgs/os-specific/linux/kernel/generic.nix` (which you can influence by
overriding `extraConfig, autoModules,
   modDirVersion, preferBuiltin, extraConfig`).

```nix
mptcp93.override ({
  name="mptcp-local";

  ignoreConfigErrors = true;
  autoModules = false;
  kernelPreferBuiltin = true;

  enableParallelBuilding = true;

  extraConfig = ''
    DEBUG_KERNEL y
    FRAME_POINTER y
    KGDB y
    KGDB_SERIAL_CONSOLE y
    DEBUG_INFO y
  '';
});
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
