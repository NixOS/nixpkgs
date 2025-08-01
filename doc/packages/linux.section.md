# Linux kernel {#sec-linux-kernel}

The Nix expressions to build the Linux kernel are in [`pkgs/os-specific/linux/kernel`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/kernel).

The function [`pkgs.buildLinux`](https://github.com/NixOS/nixpkgs/blob/d77bda728d5041c1294a68fb25c79e2d161f62b9/pkgs/os-specific/linux/kernel/generic.nix) builds a kernel with [common configuration values](https://github.com/NixOS/nixpkgs/blob/d77bda728d5041c1294a68fb25c79e2d161f62b9/pkgs/os-specific/linux/kernel/common-config.nix).
This is the preferred option unless you have a very specific use case.
Most kernels packaged in Nixpkgs are built that way, and it will also generate kernels suitable for NixOS.
[`pkgs.linuxManualConfig`](https://github.com/NixOS/nixpkgs/blob/d77bda728d5041c1294a68fb25c79e2d161f62b9/pkgs/os-specific/linux/kernel/manual-config.nix) requires a complete configuration to be passed.
It has fewer additional features than `pkgs.buildLinux`, which provides common configuration values and exposes the `features` attribute, as explained below.

Both functions have an argument `kernelPatches` which should be a list of `{name, patch, extraConfig}` attribute sets, where `name` is the name of the patch (which is included in the kernel’s `meta.description` attribute), `patch` is the patch itself (possibly compressed), and `extraConfig` (optional) is a string specifying extra options to be concatenated to the kernel configuration file (`.config`).

The kernel derivation created with `pkgs.buildLinux` exports an attribute `features` specifying whether optional functionality is or isn’t enabled. This is used in NixOS to implement kernel-specific behaviour.

If you are using a kernel packaged in Nixpkgs, you can customize it by overriding its arguments. For details on how each argument affects the generated kernel, refer to [the `pkgs.buildLinux` source code](https://github.com/NixOS/nixpkgs/blob/d77bda728d5041c1294a68fb25c79e2d161f62b9/pkgs/os-specific/linux/kernel/generic.nix).

:::{.example #ex-overriding-kernel-derivation}

# Overriding the kernel derivation

Assuming you are using the kernel from `pkgs.linux_latest`:

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

:::

## Manual kernel configuration {#sec-manual-kernel-configuration}

Sometimes it may not be desirable to use kernels built with `pkgs.buildLinux`, especially if most of the common configuration has to be altered or disabled to achieve a kernel as expected by the target use case.
An example of this is building a kernel for use in a VM or micro VM. You can use `pkgs.linuxPackages_custom` in these cases. It requires the `src`, `version`, and `configfile` attributes to be specified.

:::{.example #ex-using-linux-manual-config}

# Using `pkgs.linuxPackages_custom` with a specific source, version, and config file

```nix
{ pkgs, ... }:
pkgs.linuxPackages_custom {
  version = "6.1.55";
  src = pkgs.fetchurl {
    url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${version}.tar.xz";
    hash = "sha256-qH4kHsFdU0UsTv4hlxOjdp2IzENrW5jPbvsmLEr/FcA=";
  };
  configfile = ./path_to_config_file;
}
```

If necessary, the version string can be slightly modified to explicitly mark it as a custom version. If you do so, ensure the `modDirVersion` attribute matches the source's version, otherwise the build will fail.

```nix
{ pkgs, ... }:
pkgs.linuxPackages_custom {
  version = "6.1.55-custom";
  modDirVersion = "6.1.55";
  src = pkgs.fetchurl {
    url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${modDirVersion}.tar.xz";
    hash = "sha256-qH4kHsFdU0UsTv4hlxOjdp2IzENrW5jPbvsmLEr/FcA=";
  };
  configfile = ./path_to_config_file;
}
```

:::

Additional attributes can be used with `linuxManualConfig` for further customisation instead of `linuxPackages_custom`. You're encouraged to read [the `pkgs.linuxManualConfig` source code](https://github.com/NixOS/nixpkgs/blob/d77bda728d5041c1294a68fb25c79e2d161f62b9/pkgs/os-specific/linux/kernel/manual-config.nix) to understand how to use them.

To edit the `.config` file for Linux X.Y from within Nix, proceed as follows:

```ShellSession
$ nix-shell '<nixpkgs>' -A linuxKernel.kernels.linux_X_Y.configEnv
$ unpackPhase
$ cd linux-*
$ make nconfig
```

## Developing kernel modules {#sec-linux-kernel-developing-modules}

When developing kernel modules it's often convenient to run the edit-compile-run loop as quickly as possible.
See the snippet below as an example.

:::{.example #ex-edit-compile-run-kernel-modules}

# Edit-compile-run loop when developing `mellanox` drivers

```ShellSession
$ nix-build '<nixpkgs>' -A linuxPackages.kernel.dev
$ nix-shell '<nixpkgs>' -A linuxPackages.kernel
$ unpackPhase
$ cd linux-*
$ make -C $dev/lib/modules/*/build M=$(pwd)/drivers/net/ethernet/mellanox modules
# insmod ./drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko
```

:::
