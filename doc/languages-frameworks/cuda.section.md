# CUDA {#cuda}

CUDA-only packages are stored in the `cudaPackages` packages set. This set
includes the `cudatoolkit`, portions of the toolkit in separate derivations,
`cudnn`, `cutensor` and `nccl`.

A package set is available for each CUDA version, so for example
`cudaPackages_11_6`. Within each set is a matching version of the above listed
packages. Additionally, other versions of the packages that are packaged and
compatible are available as well. For example, there can be a
`cudaPackages.cudnn_8_3` package.

To use one or more CUDA packages in an expression, give the expression a `cudaPackages` parameter, and in case CUDA is optional
```nix
{ config
, cudaSupport ? config.cudaSupport
, cudaPackages ? { }
, ...
}:
```

When using `callPackage`, you can choose to pass in a different variant, e.g.
when a different version of the toolkit suffices
```nix
mypkg = callPackage { cudaPackages = cudaPackages_11_5; }
```

If another version of say `cudnn` or `cutensor` is needed, you can override the
package set to make it the default. This guarantees you get a consistent package
set.
```nix
mypkg = let
  cudaPackages = cudaPackages_11_5.overrideScope (final: prev: {
    cudnn = prev.cudnn_8_3;
  }});
in callPackage { inherit cudaPackages; };
```

The CUDA NVCC compiler requires flags to determine which hardware you
want to target for in terms of SASS (real hardware) or PTX (JIT kernels).

Nixpkgs tries to target support real architecture defaults based on the
CUDA toolkit version with PTX support for future hardware.  Experienced
users may optimize this configuration for a variety of reasons such as
reducing binary size and compile time, supporting legacy hardware, or
optimizing for specific hardware.

You may provide capabilities to add support or reduce binary size through
`config` using `cudaCapabilities = [ "6.0" "7.0" ];` and
`cudaForwardCompat = true;` if you want PTX support for future hardware.

Please consult [GPUs supported](https://en.wikipedia.org/wiki/CUDA#GPUs_supported)
for your specific card(s).

Library maintainers should consult [NVCC Docs](https://docs.nvidia.com/cuda/cuda-compiler-driver-nvcc/)
and release notes for their software package.

## Adding a new CUDA release {#adding-a-new-cuda-release}

> **WARNING**
>
> This section of the docs is still very much in progress. Feedback is welcome in GitHub Issues tagging @NixOS/cuda-maintainers or on [Matrix](https://matrix.to/#/#cuda:nixos.org).

The CUDA Toolkit is a suite of CUDA libraries and software meant to provide a development environment for CUDA-accelerated applications. Until the release of CUDA 11.4, NVIDIA had only made the CUDA Toolkit available as a multi-gigabyte runfile installer, which we provide through the [`cudaPackages.cudatoolkit`](https://search.nixos.org/packages?channel=unstable&type=packages&query=cudaPackages.cudatoolkit) attribute. From CUDA 11.4 and onwards, NVIDIA has also provided CUDA redistributables (“CUDA-redist”): individually packaged CUDA Toolkit components meant to facilitate redistribution and inclusion in downstream projects. These packages are available in the [`cudaPackages`](https://search.nixos.org/packages?channel=unstable&type=packages&query=cudaPackages) package set.

All new projects should use the CUDA redistributables available in [`cudaPackages`](https://search.nixos.org/packages?channel=unstable&type=packages&query=cudaPackages) in place of [`cudaPackages.cudatoolkit`](https://search.nixos.org/packages?channel=unstable&type=packages&query=cudaPackages.cudatoolkit), as they are much easier to maintain and update.

### Updating CUDA redistributables {#updating-cuda-redistributables}

1. Go to NVIDIA's index of CUDA redistributables: <https://developer.download.nvidia.com/compute/cuda/redist/>
2. Make a note of the new version of CUDA available.
3. Run

   ```bash
   nix run github:connorbaker/cuda-redist-find-features -- \
      download-manifests \
      --log-level DEBUG \
      --version <newest CUDA version> \
      https://developer.download.nvidia.com/compute/cuda/redist \
      ./pkgs/development/cuda-modules/cuda/manifests
   ```

   This will download a copy of the manifest for the new version of CUDA.
4. Run

   ```bash
   nix run github:connorbaker/cuda-redist-find-features -- \
      process-manifests \
      --log-level DEBUG \
      --version <newest CUDA version> \
      https://developer.download.nvidia.com/compute/cuda/redist \
      ./pkgs/development/cuda-modules/cuda/manifests
   ```

   This will generate a `redistrib_features_<newest CUDA version>.json` file in the same directory as the manifest.
5. Update the `cudaVersionMap` attribute set in `pkgs/development/cuda-modules/cuda/extension.nix`.

### Updating cuTensor {#updating-cutensor}

1. Repeat the steps present in [Updating CUDA redistributables](#updating-cuda-redistributables) with the following changes:
   - Use the index of cuTensor redistributables: <https://developer.download.nvidia.com/compute/cutensor/redist>
   - Use the newest version of cuTensor available instead of the newest version of CUDA.
   - Use `pkgs/development/cuda-modules/cutensor/manifests` instead of `pkgs/development/cuda-modules/cuda/manifests`.
   - Skip the step of updating `cudaVersionMap` in `pkgs/development/cuda-modules/cuda/extension.nix`.

### Updating supported compilers and GPUs {#updating-supported-compilers-and-gpus}

1. Update `nvcc-compatibilities.nix` in `pkgs/development/cuda-modules/` to include the newest release of NVCC, as well as any newly supported host compilers.
2. Update `gpus.nix` in `pkgs/development/cuda-modules/` to include any new GPUs supported by the new release of CUDA.

### Updating the CUDA Toolkit runfile installer {#updating-the-cuda-toolkit}

> **WARNING**
>
> While the CUDA Toolkit runfile installer is still available in Nixpkgs as the [`cudaPackages.cudatoolkit`](https://search.nixos.org/packages?channel=unstable&type=packages&query=cudaPackages.cudatoolkit) attribute, its use is not recommended and should it be considered deprecated. Please migrate to the CUDA redistributables provided by the [`cudaPackages`](https://search.nixos.org/packages?channel=unstable&type=packages&query=cudaPackages) package set.
>
> To ensure packages relying on the CUDA Toolkit runfile installer continue to build, it will continue to be updated until a migration path is available.

1. Go to NVIDIA's CUDA Toolkit runfile installer download page: <https://developer.nvidia.com/cuda-downloads>
2. Select the appropriate OS, architecture, distribution, and version, and installer type.

   - For example: Linux, x86_64, Ubuntu, 22.04, runfile (local)
   - NOTE: Typically, we use the Ubuntu runfile. It is unclear if the runfile for other distributions will work.

3. Take the link provided by the installer instructions on the webpage after selecting the installer type and get its hash by running:

   ```bash
   nix store prefetch-file --hash-type sha256 <link>
   ```

4. Update `pkgs/development/cuda-modules/cudatoolkit/releases.nix` to include the release.

### Updating the CUDA package set {#updating-the-cuda-package-set}

1. Include a new `cudaPackages_<major>_<minor>` package set in `pkgs/top-level/all-packages.nix`.

   - NOTE: Changing the default CUDA package set should occur in a separate PR, allowing time for additional testing.

2. Successfully build the closure of the new package set, updating `pkgs/development/cuda-modules/cuda/overrides.nix` as needed. Below are some common failures:

| Unable to ... | During ... | Reason | Solution | Note |
| --- | --- | --- | --- | --- |
| Find headers | `configurePhase` or `buildPhase` | Missing dependency on a `dev` output | Add the missing dependency | The `dev` output typically contain the headers |
| Find libraries | `configurePhase` | Missing dependency on a `dev` output | Add the missing dependency | The `dev` output typically contain CMake configuration files |
| Find libraries | `buildPhase` or `patchelf` | Missing dependency on a `lib` or `static` output | Add the missing dependency | The `lib` or `static` output typically contain the libraries |

In the scenario you are unable to run the resulting binary: this is arguably the most complicated as it could be any combination of the previous reasons. This type of failure typically occurs when a library attempts to load or open a library it depends on that it does not declare in its `DT_NEEDED` section. As a first step, ensure that dependencies are patched with [`cudaPackages.autoAddDriverRunpath`](https://search.nixos.org/packages?channel=unstable&type=packages&query=cudaPackages.autoAddDriverRunpath). Failing that, try running the application with [`nixGL`](https://github.com/guibou/nixGL) or a similar wrapper tool. If that works, it likely means that the application is attempting to load a library that is not in the `RPATH` or `RUNPATH` of the binary.
