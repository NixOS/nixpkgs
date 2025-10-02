# CUDA {#cuda}

Compute Unified Device Architecture (CUDA) is a parallel computing platform and application programming interface (API) model created by NVIDIA. It's commonly used to accelerate computationally intensive problems and has been widely adopted for high-performance computing (HPC) and machine learning (ML) applications.

## User Guide {#cuda-user-guide}

Packages provided by NVIDIA which require CUDA are typically stored in CUDA package sets.

Nixpkgs provides a number of CUDA package sets, each based on a different CUDA release. Top-level attributes that provide access to CUDA package sets follow these naming conventions:

- `cudaPackages_x_y`: A major-minor-versioned package set for a specific CUDA release, where `x` and `y` are the major and minor versions of the CUDA release.
- `cudaPackages_x`: A major-versioned alias to the major-minor-versioned CUDA package set with the latest widely supported major CUDA release.
- `cudaPackages`: An unversioned alias to the major-versioned alias for the latest widely supported CUDA release. The package set referenced by this alias is also referred to as the "default" CUDA package set.

It is recommended to use the unversioned `cudaPackages` attribute. While versioned package sets are available (e.g., `cudaPackages_12_8`), they are periodically removed.

Here are two examples to illustrate the naming conventions:

- If `cudaPackages_12_9` is the latest release in the 12.x series, but core libraries like OpenCV or ONNX Runtime fail to build with it, `cudaPackages_12` may alias `cudaPackages_12_8` instead of `cudaPackages_12_9`.
- If `cudaPackages_13_1` is the latest release, but core libraries like PyTorch or Torch Vision fail to build with it, `cudaPackages` may alias `cudaPackages_12` instead of `cudaPackages_13`.

All CUDA package sets include common CUDA packages like `libcublas`, `cudnn`, `tensorrt`, and `nccl`.

### Configuring Nixpkgs for CUDA {#cuda-configuring-nixpkgs-for-cuda}

CUDA support is not enabled by default in Nixpkgs. To enable CUDA support, make sure Nixpkgs is imported with a configuration similar to the following:

```nix
{
  allowUnfreePredicate =
    let
      ensureList = x: if builtins.isList x then x else [ x ];
    in
    package:
    builtins.all (
      license:
      license.free
      || builtins.elem license.shortName [
        "CUDA EULA"
        "cuDNN EULA"
        "cuSPARSELt EULA"
        "cuTENSOR EULA"
        "NVidia OptiX EULA"
      ]
    ) (ensureList package.meta.license);
  cudaCapabilities = [ <target-architectures> ];
  cudaForwardCompat = true;
  cudaSupport = true;
}
```

The majority of CUDA packages are unfree, so either `allowUnfreePredicate` or `allowUnfree` should be set.

The `cudaSupport` configuration option is used by packages to conditionally enable CUDA-specific functionality. This configuration option is commonly used by packages which can be built with or without CUDA support.

The `cudaCapabilities` configuration option specifies a list of CUDA capabilities. Packages may use this option to control device code generation to take advantage of architecture-specific functionality, speed up compile times by producing less device code, or slim package closures. For example, you can build for Ada Lovelace GPUs with `cudaCapabilities = [ "8.9" ];`. If `cudaCapabilities` is not provided, the default value is calculated per-package set, derived from a list of GPUs supported by that CUDA version. Please consult [supported GPUs](https://en.wikipedia.org/wiki/CUDA#GPUs_supported) for specific cards. Library maintainers should consult [NVCC Docs](https://docs.nvidia.com/cuda/cuda-compiler-driver-nvcc/) and its release notes.

::: {.caution}
Certain CUDA capabilities are not targeted by default, including capabilities belonging to the Jetson family of devices (e.g. `8.7`, which corresponds to the Jetson Orin) or non-baseline feature-sets (e.g. `9.0a`, which corresponds to the Hopper exclusive feature set). If you need to target these capabilities, you must explicitly set `cudaCapabilities` to include them.
:::

The `cudaForwardCompat` boolean configuration option determines whether PTX support for future hardware is enabled.

### Modifying CUDA package sets {#cuda-modifying-cuda-package-sets}

CUDA package sets are created by using `callPackage` on `pkgs/top-level/cuda-packages.nix` with an explicit argument for `cudaMajorMinorVersion`, a string of the form `"<major>.<minor>"` (e.g., `"12.2"`), which informs the CUDA package set tooling which version of CUDA to use. The majority of the CUDA package set tooling is available through the top-level attribute set `_cuda`, a fixed-point defined outside the CUDA package sets.

::: {.caution}
The `cudaMajorMinorVersion` and `_cuda` attributes are not part of the CUDA package set fixed-point, but are instead provided by `callPackage` from the top-level in the construction of the package set. As such, they must be modified via the package set's `override` attribute.
:::

::: {.caution}
As indicated by the underscore prefix, `_cuda` is an implementation detail and no guarantees are provided with respect to its stability or API. The `_cuda` attribute set is exposed only to ease creation or modification of CUDA package sets by expert, out-of-tree users.
:::

::: {.note}
The `_cuda` attribute set fixed-point should be modified through its `extend` attribute.
:::

The `_cuda.fixups` attribute set is a mapping from package name (`pname`) to a `callPackage`-compatible expression which will be provided to `overrideAttrs` on the result of our generic builder.

::: {.caution}
Fixups are chosen from `_cuda.fixups` by `pname`. As a result, packages with multiple versions (e.g., `cudnn`, `cudnn_8_9`, etc.) all share a single fixup function (i.e., `_cuda.fixups.cudnn`, which is `pkgs/development/cuda-modules/fixups/cudnn.nix`).
:::

As an example, you can change the fixup function used for cuDNN for only the default CUDA package set with this overlay:

```nix
final: prev: {
  cudaPackages = prev.cudaPackages.override (prevArgs: {
    _cuda = prevArgs._cuda.extend (
      _: prevAttrs: {
        fixups = prevAttrs.fixups // {
          cudnn = <your-fixup-function>;
        };
      }
    );
  });
}
```

### Extending CUDA package sets {#cuda-extending-cuda-package-sets}

CUDA package sets are scopes and provide the usual `overrideScope` attribute for overriding package attributes (see the note about `cudaMajorMinorVersion` and `_cuda` in [Configuring CUDA package sets](#cuda-modifying-cuda-package-sets)).

Inspired by `pythonPackagesExtensions`, the `_cuda.extensions` attribute is a list of extensions applied to every version of the CUDA package set, allowing modification of all versions of the CUDA package set without needing to know their names or explicitly enumerate and modify them. As an example, disabling `cuda_compat` across all CUDA package sets can be accomplished with this overlay:

```nix
final: prev: {
  _cuda = prev._cuda.extend (
    _: prevAttrs: {
      extensions = prevAttrs.extensions ++ [ (_: _: { cuda_compat = null; }) ];
    }
  );
}
```

### Using `cudaPackages` {#cuda-using-cudapackages}

::: {.caution}
A non-trivial amount of CUDA package discoverability and usability relies on the various setup hooks used by a CUDA package set. As a result, users will likely encounter issues trying to perform builds within a `devShell` without manually invoking phases.
:::

To use one or more CUDA packages in an expression, give the expression a `cudaPackages` parameter, and in case CUDA support is optional, add a `config` and `cudaSupport` parameter:

```nix
{
  config,
  cudaSupport ? config.cudaSupport,
  cudaPackages,
}:
<package-expression>
```

In your package's derivation arguments, it is _strongly_ recommended that the following are set:

```nix
{
  __structuredAttrs = true;
  strictDeps = true;
}
```

These settings ensure that the CUDA setup hooks function as intended.

When using `callPackage`, you can choose to pass in a different variant, e.g. when a package requires a specific version of CUDA:

```nix
{ mypkg = callPackage { cudaPackages = cudaPackages_12_6; }; }
```

::: {.caution}
Overriding the CUDA package set for a package may cause inconsistencies, because the override does not affect its direct or transitive dependencies. As a result, it is easy to end up with a package that use a different CUDA package set than its dependencies. If possible, it is recommended that you change the default CUDA package set globally, to ensure a consistent environment.
:::

### Nixpkgs CUDA variants {#cuda-nixpkgs-cuda-variants}

Nixpkgs CUDA variants are provided primarily for the convenience of selecting CUDA-enabled packages by attribute path. As an example, the `pkgsForCudaArch` collection of CUDA Nixpkgs variants allows you to access an instantiation of OpenCV with CUDA support for an Ada Lovelace GPU with the attribute path `pkgsForCudaArch.sm_89.opencv`, without needing to modify the `config` provided when importing Nixpkgs.

::: {.caution}
Nixpkgs variants are not free: they require re-evaluating Nixpkgs. Where possible, import Nixpkgs once, with the desired configuration.
:::

#### Using `cudaPackages.pkgs` {#cuda-using-cudapackages-pkgs}

Each CUDA package set has a `pkgs` attribute, which is a variant of Nixpkgs in which the enclosing CUDA package set becomes the default. This was done primarily to avoid package set leakage, wherein a member of a non-default CUDA package set has a (potentially transitive) dependency on a member of the default CUDA package set.

::: {.note}
Package set leakage is a common problem in Nixpkgs and is not limited to CUDA package sets.
:::

As an added benefit of `pkgs` being configured this way, building a package with a non-default version of CUDA is as simple as accessing an attribute. As an example, `cudaPackages_12_8.pkgs.opencv` provides OpenCV built against CUDA 12.8.

#### Using `pkgsCuda` {#cuda-using-pkgscuda}

The `pkgsCuda` attribute set is a variant of Nixpkgs configured with `cudaSupport = true;` and `rocmSupport = false`. It is a convenient way to access a variant of Nixpkgs configured with the default set of CUDA capabilities.

#### Using `pkgsForCudaArch` {#cuda-using-pkgsforcudaarch}

The `pkgsForCudaArch` attribute set maps CUDA architectures (e.g., `sm_89` for Ada Lovelace or `sm_90a` for architecture-specific Hopper) to Nixpkgs variants configured to support exactly that architecture. As an example, `pkgsForCudaArch.sm_89` is a Nixpkgs variant extending `pkgs` and setting the following values in `config`:

```nix
{
  cudaSupport = true;
  cudaCapabilities = [ "8.9" ];
  cudaForwardCompat = false;
}
```

::: {.note}
In `pkgsForCudaArch`, the `cudaForwardCompat` option is set to `false` because exactly one CUDA architecture is supported by the corresponding Nixpkgs variant. Furthermore, some architectures, including architecture-specific feature sets like `sm_90a`, cannot be built with forward compatibility.
:::

::: {.caution}
Not every version of CUDA supports every architecture!

To illustrate: support for Blackwell (e.g., `sm_100`) was added in CUDA 12.8. Assume our Nixpkgs' default CUDA package set is to CUDA 12.6. Then the Nixpkgs variant available through `pkgsForCudaArch.sm_100` is useless, since packages like `pkgsForCudaArch.sm_100.opencv` and `pkgsForCudaArch.sm_100.python3Packages.torch` will try to generate code for `sm_100`, an architecture unknown to CUDA 12.6. In that case, you should use `pkgsForCudaArch.sm_100.cudaPackages_12_8.pkgs` instead (see [Using cudaPackages.pkgs](#cuda-using-cudapackages-pkgs) for more details).
:::

The `pkgsForCudaArch` attribute set makes it possible to access packages built for a specific architecture without needing to manually call `pkgs.extend` and supply a new `config`. As an example, `pkgsForCudaArch.sm_89.python3Packages.torch` provides PyTorch built for Ada Lovelace GPUs.

### Running Docker or Podman containers with CUDA support {#cuda-docker-podman}

It is possible to run Docker or Podman containers with CUDA support. The recommended mechanism to perform this task is to use the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/index.html).

The NVIDIA Container Toolkit can be enabled in NixOS like follows:

```nix
{ hardware.nvidia-container-toolkit.enable = true; }
```

This will automatically enable a service that generates a CDI specification (located at `/var/run/cdi/nvidia-container-toolkit.json`) based on the auto-detected hardware of your machine. You can check this service by running:

```ShellSession
$ systemctl status nvidia-container-toolkit-cdi-generator.service
```

::: {.note}
Depending on what settings you had already enabled in your system, you might need to restart your machine in order for the NVIDIA Container Toolkit to generate a valid CDI specification for your machine.
:::

Once that a valid CDI specification has been generated for your machine on boot time, both Podman and Docker (> 25) will use this spec if you provide them with the `--device` flag:

```ShellSession
$ podman run --rm -it --device=nvidia.com/gpu=all ubuntu:latest nvidia-smi -L
GPU 0: NVIDIA GeForce RTX 4090 (UUID: <REDACTED>)
GPU 1: NVIDIA GeForce RTX 2080 SUPER (UUID: <REDACTED>)
```

```ShellSession
$ docker run --rm -it --device=nvidia.com/gpu=all ubuntu:latest nvidia-smi -L
GPU 0: NVIDIA GeForce RTX 4090 (UUID: <REDACTED>)
GPU 1: NVIDIA GeForce RTX 2080 SUPER (UUID: <REDACTED>)
```

You can check all the identifiers that have been generated for your auto-detected hardware by checking the contents of the `/var/run/cdi/nvidia-container-toolkit.json` file:

```ShellSession
$ nix run nixpkgs#jq -- -r '.devices[].name' < /var/run/cdi/nvidia-container-toolkit.json
0
1
all
```

#### Specifying what devices to expose to the container {#cuda-specifying-what-devices-to-expose-to-the-container}

You can choose what devices are exposed to your containers by using the identifier on the generated CDI specification. Like follows:

```ShellSession
$ podman run --rm -it --device=nvidia.com/gpu=0 ubuntu:latest nvidia-smi -L
GPU 0: NVIDIA GeForce RTX 4090 (UUID: <REDACTED>)
```

You can repeat the `--device` argument as many times as necessary if you have multiple GPU's and you want to pick up which ones to expose to the container:

```ShellSession
$ podman run --rm -it --device=nvidia.com/gpu=0 --device=nvidia.com/gpu=1 ubuntu:latest nvidia-smi -L
GPU 0: NVIDIA GeForce RTX 4090 (UUID: <REDACTED>)
GPU 1: NVIDIA GeForce RTX 2080 SUPER (UUID: <REDACTED>)
```

::: {.note}
By default, the NVIDIA Container Toolkit will use the GPU index to identify specific devices. You can change the way to identify what devices to expose by using the `hardware.nvidia-container-toolkit.device-name-strategy` NixOS attribute.
:::

#### Using docker-compose {#cuda-using-docker-compose}

It's possible to expose GPUs to a `docker-compose` environment as well. With a `docker-compose.yaml` file like follows:

```yaml
services:
  some-service:
    image: ubuntu:latest
    command: sleep infinity
    deploy:
      resources:
        reservations:
          devices:
          - driver: cdi
            device_ids:
            - nvidia.com/gpu=all
```

In the same manner, you can pick specific devices that will be exposed to the container:

```yaml
services:
  some-service:
    image: ubuntu:latest
    command: sleep infinity
    deploy:
      resources:
        reservations:
          devices:
          - driver: cdi
            device_ids:
            - nvidia.com/gpu=0
            - nvidia.com/gpu=1
```

## Contributing {#cuda-contributing}

::: {.warning}
This section of the docs is still very much in progress. Feedback is welcome in GitHub Issues tagging @NixOS/cuda-maintainers or on [Matrix](https://matrix.to/#/#cuda:nixos.org).
:::

### Package set maintenance {#cuda-package-set-maintenance}

The CUDA Toolkit is a suite of CUDA libraries and software meant to provide a development environment for CUDA-accelerated applications. Until the release of CUDA 11.4, NVIDIA had only made the CUDA Toolkit available as a multi-gigabyte runfile installer, which we provide through the [`cudaPackages.cudatoolkit`](https://search.nixos.org/packages?channel=unstable&type=packages&query=cudaPackages.cudatoolkit) attribute. From CUDA 11.4 and onwards, NVIDIA has also provided CUDA redistributables (“CUDA-redist”): individually packaged CUDA Toolkit components meant to facilitate redistribution and inclusion in downstream projects. These packages are available in the [`cudaPackages`](https://search.nixos.org/packages?channel=unstable&type=packages&query=cudaPackages) package set.

All new projects should use the CUDA redistributables available in [`cudaPackages`](https://search.nixos.org/packages?channel=unstable&type=packages&query=cudaPackages) in place of [`cudaPackages.cudatoolkit`](https://search.nixos.org/packages?channel=unstable&type=packages&query=cudaPackages.cudatoolkit), as they are much easier to maintain and update.

#### Updating redistributables {#cuda-updating-redistributables}

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

#### Updating cuTensor {#cuda-updating-cutensor}

1. Repeat the steps present in [Updating CUDA redistributables](#cuda-updating-redistributables) with the following changes:
   - Use the index of cuTensor redistributables: <https://developer.download.nvidia.com/compute/cutensor/redist>
   - Use the newest version of cuTensor available instead of the newest version of CUDA.
   - Use `pkgs/development/cuda-modules/cutensor/manifests` instead of `pkgs/development/cuda-modules/cuda/manifests`.
   - Skip the step of updating `cudaVersionMap` in `pkgs/development/cuda-modules/cuda/extension.nix`.

#### Updating supported compilers and GPUs {#cuda-updating-supported-compilers-and-gpus}

1. Update `nvccCompatibilities` in `pkgs/development/cuda-modules/_cuda/data/nvcc.nix` to include the newest release of NVCC, as well as any newly supported host compilers.
2. Update `cudaCapabilityToInfo` in `pkgs/development/cuda-modules/_cuda/data/cuda.nix` to include any new GPUs supported by the new release of CUDA.

#### Updating the CUDA Toolkit runfile installer {#cuda-updating-the-cuda-toolkit}

::: {.warning}
While the CUDA Toolkit runfile installer is still available in Nixpkgs as the [`cudaPackages.cudatoolkit`](https://search.nixos.org/packages?channel=unstable&type=packages&query=cudaPackages.cudatoolkit) attribute, its use is not recommended, and it should be considered deprecated. Please migrate to the CUDA redistributables provided by the [`cudaPackages`](https://search.nixos.org/packages?channel=unstable&type=packages&query=cudaPackages) package set.

To ensure packages relying on the CUDA Toolkit runfile installer continue to build, it will continue to be updated until a migration path is available.
:::

1. Go to NVIDIA's CUDA Toolkit runfile installer download page: <https://developer.nvidia.com/cuda-downloads>
2. Select the appropriate OS, architecture, distribution, and version, and installer type.

   - For example: Linux, x86_64, Ubuntu, 22.04, runfile (local)
   - NOTE: Typically, we use the Ubuntu runfile. It is unclear if the runfile for other distributions will work.

3. Take the link provided by the installer instructions on the webpage after selecting the installer type and get its hash by running:

   ```bash
   nix store prefetch-file --hash-type sha256 <link>
   ```

4. Update `pkgs/development/cuda-modules/cudatoolkit/releases.nix` to include the release.

#### Updating the CUDA package set {#cuda-updating-the-cuda-package-set}

1. Include a new `cudaPackages_<major>_<minor>` package set in `pkgs/top-level/all-packages.nix`.

   - NOTE: Changing the default CUDA package set should occur in a separate PR, allowing time for additional testing.

2. Successfully build the closure of the new package set, updating `pkgs/development/cuda-modules/cuda/overrides.nix` as needed. Below are some common failures:

| Unable to ...  | During ...                       | Reason                                           | Solution                   | Note                                                         |
| -------------- | -------------------------------- | ------------------------------------------------ | -------------------------- | ------------------------------------------------------------ |
| Find headers   | `configurePhase` or `buildPhase` | Missing dependency on a `dev` output             | Add the missing dependency | The `dev` output typically contains the headers               |
| Find libraries | `configurePhase`                 | Missing dependency on a `dev` output             | Add the missing dependency | The `dev` output typically contains CMake configuration files |
| Find libraries | `buildPhase` or `patchelf`       | Missing dependency on a `lib` or `static` output | Add the missing dependency | The `lib` or `static` output typically contains the libraries |

Failure to run the resulting binary is typically the most challenging to diagnose, as it may involve a combination of the aforementioned issues. This type of failure typically occurs when a library attempts to load or open a library it depends on that it does not declare in its `DT_NEEDED` section. Try the following debugging steps:

1. First ensure that dependencies are patched with [`autoAddDriverRunpath`](https://search.nixos.org/packages?channel=unstable&type=packages&query=autoAddDriverRunpath).
2. Failing that, try running the application with [`nixGL`](https://github.com/guibou/nixGL) or a similar wrapper tool.
3. If that works, it likely means that the application is attempting to load a library that is not in the `RPATH` or `RUNPATH` of the binary.

### Writing tests {#cuda-writing-tests}

::: {.caution}
The existence of `passthru.testers` and `passthru.tests` should be considered an implementation detail -- they are not meant to be a public or stable interface.
:::

In general, there are two attribute sets in `passthru` that are used to build and run tests for CUDA packages: `passthru.testers` and `passthru.tests`. Each attribute set may contain an attribute set named `cuda`, which contains CUDA-specific derivations. The `cuda` attribute set is used to separate CUDA-specific derivations from those which support multiple implementations (e.g., OpenCL, ROCm, etc.) or have different licenses. For an example of such generic derivations, see the `magma` package.

::: {.note}
Derivations are nested under the `cuda` attribute due to an OfBorg quirk: if evaluation fails (e.g., because of unfree licenses), the entire enclosing attribute set is discarded. This prevents other attributes in the set from being discovered, evaluated, or built.
:::

#### `passthru.testers` {#cuda-passthru-testers}

Attributes added to `passthru.testers` are derivations which produce an executable which runs a test. The produced executable should:

- Take care to set up the environment, make temporary directories, and so on.
- Be registered as the derivation's `meta.mainProgram` so that it can be run directly.

::: {.note}
Testers which always require CUDA should be placed in `passthru.testers.cuda`, while those which are generic should be placed in `passthru.testers`.
:::

The `passthru.testers` attribute set allows running tests outside the Nix sandbox. There are a number of reasons why this is useful, since such a test:

- Can be run on non-NixOS systems, when wrapped with utilities like `nixGL` or `nix-gl-host`.
- Has network access patterns which are difficult or impossible to sandbox.
- Is free to produce output which is not deterministic, such as timing information.

#### `passthru.tests` {#cuda-passthru-tests}

Attributes added to `passthru.tests` are derivations which run tests inside the Nix sandbox. Tests should:

- Use the executables produced by `passthru.testers`, where possible, to avoid duplication of test logic.
- Include `requiredSystemFeatures = [ "cuda" ];`, possibly conditioned on the value of `cudaSupport` if they are generic, to ensure that they are only run on systems exposing a CUDA-capable GPU.

::: {.note}
Tests which always require CUDA should be placed in `passthru.tests.cuda`, while those which are generic should be placed in `passthru.tests`.
:::

This is useful for tests which are deterministic (e.g., checking exit codes) and which can be provided with all necessary resources in the sandbox.
