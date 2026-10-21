# Linux kernel {#sec-linux-kernel}

The Nix expressions to build the Linux kernel are in [`pkgs/os-specific/linux/kernel`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/kernel).

The function [`pkgs.buildLinux`](https://github.com/NixOS/nixpkgs/blob/d77bda728d5041c1294a68fb25c79e2d161f62b9/pkgs/os-specific/linux/kernel/generic.nix) builds a kernel with [common configuration values](https://github.com/NixOS/nixpkgs/blob/d77bda728d5041c1294a68fb25c79e2d161f62b9/pkgs/os-specific/linux/kernel/common-config.nix).
This is the preferred option unless you have a very specific use case.
Most kernels packaged in Nixpkgs are built that way, and it will also generate kernels suitable for NixOS.
[`pkgs.linuxManualConfig`](https://github.com/NixOS/nixpkgs/blob/d77bda728d5041c1294a68fb25c79e2d161f62b9/pkgs/os-specific/linux/kernel/build.nix) requires a complete configuration to be passed.
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
  structuredExtraConfig = with lib.kernel; {
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

Additional attributes can be used with `linuxManualConfig` for further customisation instead of `linuxPackages_custom`. You're encouraged to read [the `pkgs.linuxManualConfig` source code](https://github.com/NixOS/nixpkgs/blob/d77bda728d5041c1294a68fb25c79e2d161f62b9/pkgs/os-specific/linux/kernel/build.nix) to understand how to use them.

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

## Out-of-tree kernel modules {#sec-linux-kernel-out-of-tree-modules}

Kernel module packages in `linuxPackages` install their modules through the kernel's own `modules_install`.
It strips, signs and compresses every module and emits the per-module certificate next to it.
Manually copying `.ko` files leaves modules unsigned and without a certificate, which breaks machines that aggregate external module certificates.

For module packages whose build system does not install the modules properly, use the `linuxPackages.kernelModuleInstallHook` setup hook.
It installs the modules from the current build directory into `lib/modules/${kernel.modDirVersion}/updates`:

```nix
{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleInstallHook,
}:

stdenv.mkDerivation {
  pname = "bbswitch";
  version = "unstable-2021-11-29";

  src = fetchFromGitHub {
    owner = "Bumblebee-Project";
    repo = "bbswitch";
    rev = "23891174a80ea79c7720bcc7048a5c2bfcde5cd9";
    hash = "sha256-50v1Jxem5kaI1dHOKmgBbPLxI82QeYxiaRHhrHpWRzU=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies ++ [ kernelModuleInstallHook ];

  kernelModuleInstallDir = "misc";
}
```

The hook reads these derivation attributes:

- `kernelModuleDirs` (list of strings, default: the build directory itself)

  The kbuild directories (`M=`) to install, relative to the build directory.
  Set this when the modules are built from a subdirectory, or when a package consists of several modules, e.g. `kernelModuleDirs = [ "ddcci" "ddcci-backlight" ];`.

- `kernelModuleInstallDir` (string, default: `updates`)

  Passed to kbuild as `INSTALL_MOD_DIR`, the directory below `lib/modules/${kernel.modDirVersion}/` into which the modules are installed.

- `kernelModuleSkipMissingDirs` (boolean, default: `false`)

  Skip `kernelModuleDirs` entries that do not exist instead of failing the build.
  Useful when the set of modules differs between releases of the source.

- `dontInstallKernelModules` (boolean, default: `false`)

  Do not replace the default `installPhase`.
  Set this when the derivation needs the standard `make install` or its own `installPhase`, and call the `installKernelModules` function manually instead, e.g. from `postInstall`.

:::{.example #ex-out-of-tree-module-multiple-dirs}

# Installing multiple kernel modules from subdirectories

```nix
stdenv.mkDerivation {
  nativeBuildInputs = kernel.moduleBuildDependencies ++ [ kernelModuleInstallHook ];

  kernelModuleDirs = [
    "vmblock-only"
    "vmmon-only"
    "vmnet-only"
  ];
  kernelModuleInstallDir = "misc";
  kernelModuleSkipMissingDirs = true;
}
```

:::

:::{.example #ex-out-of-tree-module-manual-call}

# Installing a kernel module alongside `make install`

Derivations that keep the standard install phase for their userspace parts call the `installKernelModules` function manually.
Do not call `installKernelModulesPhase` from a hook such as `postInstall`: it runs the `preInstall` and `postInstall` hooks and would recurse.

```nix
stdenv.mkDerivation {
  nativeBuildInputs = kernel.moduleBuildDependencies ++ [ kernelModuleInstallHook ];

  dontInstallKernelModules = true;
  kernelModuleDirs = [ "build/driver" ];

  postInstall = ''
    installKernelModules
  '';
}
```

:::

## Maintainer information {#sec-linux-kernel-maintainer-information}

### Updating kernels {#sec-linux-updates}

Updating all kernels can be done with the following script:

```ShellSession
$ pkgs/os-specific/linux/kernel/update.sh
```

The change gets submitted like this:

* File a PR against `staging-nixos`.
  * Add a `backport staging-nixos-XX.XX` label for an automated backport.
    By using an additional PR, we get the automatic backport against stable without manual cherry-picks.
* Merge into `staging-nixos` or `staging-nixos-XX.XX`.
* File as PR from `staging-nixos` against `master` or `staging-nixos-XX.XX` against `release-xx.xx`.
* When all status checks are green, merge.

### Add a new (major) version of the Linux kernel {#sec-linux-add-new-kernel-version}

* When running `./pkgs/os-specific/linux/kernel/update.sh`, new kernel majors get discovered automatically.
* Prepare all Nix expressions for the new kernel
  * Instantiate the new kernel in `pkgs/top-level/linux-kernels.nix` in the `kernels`-section.
    ```nix
    {
      linux_X_Y = callPackage ../os-specific/linux/kernel/mainline.nix {
        branch = "X.Y";
        kernelPatches = [
          # any new patches required (it makes to look which patches are used by its predecessor)
        ];
      };
    }
    ```
  * Instantiate the package-set in `vanillaPackages`:
    ```nix
    {
      linux_X_Y = recurseIntoAttrs (packagesFor kernels.linux_X_Y);
    }
    ```
  * Update `linux_latest` to the new attribute.
* __SQUASH__ the changes into the `linux: init at …` commit.

### Policy for accepting new kernel flavours {#sec-linux-new-kernels}

No new downstream kernels are accepted into nixpkgs. That includes kernels that use the mainline
sourcetree, but a different configuration. Kernels for extended hardware support should go
to [nixos-hardware](github.com/NixOS/nixos-hardware) instead.
