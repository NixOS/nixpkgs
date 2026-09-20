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
{ pkgs }:
{
  allowUnfreePredicate = pkgs._cuda.lib.allowUnfreeCudaPredicate;
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

CUDA package sets are defined in `pkgs/top-level/cuda-packages.nix`. A CUDA package set is created by `callPackage`-ing `pkgs/development/cuda-modules/default.nix` with an attribute set `manifests`, containing NVIDIA manifests for each redistributable. The manifests for supported redistributables are available through `_cuda.manifests` and live in `pkgs/development/cuda-modules/_cuda/manifests`.

The majority of the CUDA package set tooling is available through the top-level attribute set `_cuda`, a fixed-point defined outside the CUDA package sets. As a fixed-point, `_cuda` should be modified through its `extend` attribute.

::: {.caution}
As indicated by the underscore prefix, `_cuda` is an implementation detail and no guarantees are provided with respect to its stability or API. The `_cuda` attribute set is exposed only to ease creation or modification of CUDA package sets by expert, out-of-tree users.
:::

Out-of-tree modifications of packages should use `overrideAttrs` to make any necessary modifications to the package expression.

::: {.note}
The `_cuda` attribute set previously exposed `fixups`, an attribute set mapping from package name (`pname`) to a `callPackage`-compatible expression which provided to `overrideAttrs` on the result of a generic redistributable builder. This functionality has been removed in favor of including full package expressions for each redistributable package to ensure consistent attribute set membership across supported CUDA releases, platforms, and configurations.
:::

### Extending CUDA package sets {#cuda-extending-cuda-package-sets}

CUDA package sets are scopes and provide the usual `overrideScope` attribute for overriding package attributes (see the note about `_cuda` in [Configuring CUDA package sets](#cuda-modifying-cuda-package-sets)).

As with other spliced scopes, `overrideScope` changes the current platform stage; it does not change the corresponding BUILD or TARGET package sets. For example, overriding HOST's `cuda_nvcc` does not override the BUILD compiler selected for `nativeBuildInputs` during cross-compilation. To apply a customization across these stages, add it to `_cuda.extensions` through a regular Nixpkgs overlay, as shown below.

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

Redistributable packages are constructed by the `buildRedist` helper; see `pkgs/development/cuda-modules/buildRedist/default.nix` for the implementation.

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

Each CUDA package set has a `pkgs` attribute, which is a variant of Nixpkgs in which its named CUDA release becomes the default. This was done primarily to avoid package set leakage, wherein a member of a non-default CUDA package set has a (potentially transitive) dependency on a member of the default CUDA package set.

::: {.note}
Package set leakage is a common problem in Nixpkgs and is not limited to CUDA package sets.
:::

As an added benefit of `pkgs` being configured this way, building a package with a non-default version of CUDA is as simple as accessing an attribute. As an example, `cudaPackages_12_8.pkgs.opencv` provides OpenCV built against CUDA 12.8.

The variant preserves the originating Nixpkgs stage, including distinct stages
whose platform records happen to be equal. Its alias overlay applies through
the complete package graph; stage-specific overlays, including `crossOverlays`,
retain their original stage and order.
An extended package graph is shared across dependency roles with the same native
package context; stage selection does not instantiate another copy of Nixpkgs.
Distinct native bootstrap or replacement contexts keep separate caches, because
compiler selection may happen while a later stdenv is still being constructed.
Custom stage constructors must preserve stage positions when overlays change;
projection rejects a change in the number of stages.

Within the CUDA scope’s `callPackage`, the `pkgs` argument is the selected package graph with its existing splices. Explicit role references such as `pkgs.pkgsBuildHost` retain their selection; the scope does not splice that graph a second time.

This selects the named release; local `overrideScope` changes and manually overridden manifests are not automatically applied to the package sets inside `.pkgs`. Use regular Nixpkgs overlays and `_cuda.extensions` when those changes must affect the complete dependency graph.

Extensions that need packages outside CUDA should obtain them through the CUDA scope's `callPackage` or `pkgs`, for example `finalCuda.callPackage ({ ucx }: ucx) { }` or `finalCuda.pkgs.ucx`. Referring to the outer Nixpkgs overlay's `final.ucx` captures that package from the original fixed point; selecting a named CUDA scope does not rewrite captured references. The extension is also evaluated within `.pkgs`, where its outer fixed point has the selected CUDA release.

Select CUDA releases through regular `overlays`, rather than stage-specific overlays such as `crossOverlays`. These can run after the alias overlay used to construct `.pkgs` and defeat the requested release selection. CUDA checks that the named scope has the requested minor release in each dependency role and that the unspliced aliases select matching manifests within that role. A conflicting stage-specific override is rejected even if it renames all the aliases together.

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

To illustrate: support for Blackwell (e.g., `sm_100`) was added in CUDA 12.8. Assume our Nixpkgs' default CUDA package set is to CUDA 12.6. Then the Nixpkgs variant available through `pkgsForCudaArch.sm_100` is useless, since packages like `pkgsForCudaArch.sm_100.opencv` and `pkgsForCudaArch.sm_100.python3Packages.torch` will try to generate code for `sm_100`, an architecture unknown to CUDA 12.6. In that case, you should use `pkgsForCudaArch.sm_100.cudaPackages_12_8.pkgs` instead (see [Using `cudaPackages.pkgs`](#cuda-using-cudapackages-pkgs) for more details).
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

The CUDA Toolkit is a suite of CUDA libraries and software meant to provide a development environment for CUDA-accelerated applications. Until the release of CUDA 11.4, NVIDIA had only made the CUDA Toolkit available as a multi-gigabyte runfile installer. From CUDA 11.4 and onwards, NVIDIA has also provided CUDA redistributables (“CUDA-redist”): individually packaged CUDA Toolkit components meant to facilitate redistribution and inclusion in downstream projects. These packages are available in the [`cudaPackages`](https://search.nixos.org/packages?channel=unstable&type=packages&query=cudaPackages) package set.

While the monolithic CUDA Toolkit runfile installer is no longer provided, [`cudaPackages.cudatoolkit`](https://search.nixos.org/packages?channel=unstable&type=packages&query=cudaPackages.cudatoolkit) provides a `symlinkJoin`-ed approximation which common libraries. The use of [`cudaPackages.cudatoolkit`](https://search.nixos.org/packages?channel=unstable&type=packages&query=cudaPackages.cudatoolkit) is discouraged: all new projects should use the CUDA redistributables available in [`cudaPackages`](https://search.nixos.org/packages?channel=unstable&type=packages&query=cudaPackages) instead, as they are much easier to maintain and update.

#### Updating redistributables {#cuda-updating-redistributables}

Whenever a new version of a redistributable manifest is made available:

1. Check the corresponding README.md in `pkgs/development/cuda-modules/_cuda/manifests` for the URL to use when vendoring manifests.
2. Update the manifest version used in construction of each CUDA package set in `pkgs/top-level/cuda-packages.nix`.
3. Update package expressions in `pkgs/development/cuda-modules/packages`.

Updating package expressions amounts to:

- adding fixes conditioned on newer releases, like added or removed dependencies
- adding package expressions for new packages
- updating `passthru.brokenConditions` and `passthru.badPlatformsConditions` with various constraints, (e.g., new releases removing support for various architectures)

#### Updating supported compilers and GPUs {#cuda-updating-supported-compilers-and-gpus}

1. Update `nvccCompatibilities` in `pkgs/development/cuda-modules/_cuda/db/bootstrap/nvcc.nix` to include the newest release of NVCC, as well as any newly supported host compilers.
2. Update `cudaCapabilityToInfo` in `pkgs/development/cuda-modules/_cuda/db/bootstrap/cuda.nix` to include any new GPUs supported by the new release of CUDA.

#### Updating the CUDA package set {#cuda-updating-the-cuda-package-set}

::: {.note}
Changing the default CUDA package set should occur in a separate PR, allowing time for additional testing.
:::

::: {.warning}
As described in [Using `cudaPackages.pkgs`](#cuda-using-cudapackages-pkgs), the current implementation fix for package set leakage involves creating a new instance for each non-default CUDA package sets. As such, We should limit the number of CUDA package sets which have `recurseForDerivations` set to true: `lib.recurseIntoAttrs` should only be applied to the default CUDA package set.
:::

1. Include a new `cudaPackages_<major>_<minor>` package set in `pkgs/top-level/cuda-packages.nix` and inherit it in `pkgs/top-level/all-packages.nix`.
2. Successfully build the closure of the new package set, updating expressions in `pkgs/development/cuda-modules/packages` as needed. Below are some common failures:

| Unable to ...  | During ...                       | Reason                                           | Solution                   | Note                                                         |
| -------------- | -------------------------------- | ------------------------------------------------ | -------------------------- | ------------------------------------------------------------ |
| Find headers   | `configurePhase` or `buildPhase` | Missing dependency on a `dev` output             | Add the missing dependency | The `dev` output typically contains the headers               |
| Find libraries | `configurePhase`                 | Missing dependency on a `dev` output             | Add the missing dependency | The `dev` output typically contains CMake configuration files |
| Find libraries | `buildPhase` or `patchelf`       | Missing dependency on a `lib` or `static` output | Add the missing dependency | The `lib` or `static` output typically contains the libraries |

::: {.note}
Two utility derivations ease testing updates to the package set:

- `cudaPackages.tests.redists-unpacked`: the `src` of each redistributable package unpacked and `symlinkJoin`-ed
- `cudaPackages.tests.redists-installed`: each output of each redistributable package `symlinkJoin`-ed
:::

Failure to run the resulting binary is typically the most challenging to diagnose, as it may involve a combination of the aforementioned issues. This type of failure typically occurs when a library attempts to load or open a library it depends on that it does not declare in its `DT_NEEDED` section. Try the following debugging steps:

1. First ensure that dependencies are patched with [`autoAddDriverRunpath`](https://search.nixos.org/packages?channel=unstable&type=packages&query=autoAddDriverRunpath).
2. Failing that, try running the application with [`nixGL`](https://github.com/guibou/nixGL) or a similar wrapper tool.
3. If that works, it likely means that the application is attempting to load a library that is not in the `RPATH` or `RUNPATH` of the binary.

### Cross compilation {#cuda-cross-compilation}

Use the normal Nixpkgs dependency roles: put `cuda_nvcc` in `nativeBuildInputs`
and CUDA libraries in `buildInputs`. The CUDA scope is spliced separately for
each platform, including when using a non-default CUDA version.

Compiler paths embedded in strings do not undergo input splicing. For a
build-time compiler path in a Make flag or CMake argument, select
`cuda_nvcc.__spliced.buildHost or cuda_nvcc` before applying `lib.getBin` or
`lib.getExe`. Adding the original derivation to `nativeBuildInputs` only
splices that dependency entry.

Relative to the `cuda_nvcc` derivation, NVIDIA's compiler executables run on
`hostPlatform`, while its CRT and CCCL headers describe code for `targetPlatform`.
Those headers use `depsTargetTargetPropagated`; when NVCC is a native build input,
they therefore become headers for the consumer's host platform. CUDA 12's CRT
headers are extracted from the NVCC archive into `cuda_crt`, allowing `cuda_cudart`
to propagate them without propagating a compiler.

`backendCC` is the compatible C++ backend which runs on HOST and emits for
TARGET. It is a normal spliced package: `backendStdenv` uses its BUILD→HOST
splice, while NVCC uses it directly. NVCC keeps this backend private, so adding
NVCC does not replace the project's C/C++ compiler. To select a different NVCC
backend, override `cuda_nvcc`'s `backendCC` argument.

Splicing recurses into ordinary package sets, but only splices a derivation and
its named outputs. Arbitrary attributes such as `stdenv.cc` do not inherit the
enclosing derivation's splices. Keeping `backendCC` as a separate package allows
`backendStdenv` to select its BUILD→HOST splice before storing it in `.cc`.

`cudaConfig` resolves GPU capabilities and forward compatibility independently
of compiler selection. `redistSystem` selects the payload for each component's
host platform. These values are no longer attributes of `backendStdenv`, and
there is no separate `ccForTarget` selection policy. Redistributables are
packaged with `stdenvNoCC`; their C++ runtime is an explicit dependency.

The NVCC wrapper uses the standard `role.bash` markers and its backend's existing
Bintools Wrapper utilities for role-specific variables.
Its setup hook sources the existing backend wrapper hooks in a subshell and
imports their standard `addEnvHooks` collectors under names private to the NVCC
output, together with their role registrations. The backend's hardening default
is a fallback after setup activation: the enclosing stdenv and caller retain
their hardening policy. This preserves compiler-specific collection policy, such as Clang's
header-path scrubbing, when another compiler activates later. Flags within a
role still share the ordinary `NIX_*` variables. The import supports the standard
collectors; it does not capture arbitrary callbacks' private helpers or state.
Tool selection, role markers, and PATH changes stay in the subshell, so NVCC
needs no separate inventory of backend tools. The standard dependency flag
collectors also work with `stdenvNoCC`.
This does not require changes to the ordinary CC or Bintools Wrappers.
At invocation, NVCC gives its backend the same roles as that invocation.
It first discards the selected wrappers' internal flag caches: a parent
compiler may have initialized them for different roles or compiler defaults.
The existing wrapper helpers then rebuild flags from the role-specific inputs.
Dependency headers and libraries use `NIX_CFLAGS_COMPILE` and `NIX_LDFLAGS`, as
with other Nixpkgs compilers. NVCC evaluates Bintools Wrapper's `add-flags.sh` in a subshell and
passes library search paths from `NIX_LDFLAGS_BEFORE`, `NIX_LDFLAGS`, and
`NIX_LDFLAGS_AFTER` to its device linker. The actual backend initializes its own
wrapper flags and defaults; NVCC does not export its packaged backend's initialized
cache to an overriding compiler. Its private runtime PATH also supplies
the unprefixed `ar` that NVCC invokes, using the backend's target archiver.

Setup initializes `CUDAHOSTCXX` and `NVCC_CCBIN` to the selected backend; the
`_FOR_BUILD` and `_FOR_TARGET` suffixes select overrides for those roles.
After setup, `CUDAHOSTCXX` configures CMake and `NVCC_CCBIN` configures direct
NVCC invocations. Changing either variable does not override the other.
Caller-provided `NVCC_PREPEND_FLAGS` retain their usual NVCC meaning, and
command-line `--compiler-bindir` takes precedence over the default backend.
Executable basenames resolve through the caller's PATH before the packaged
backend fallback. Runtime overrides select an executable; they do not repeat
setup activation with that compiler's dependency collectors. Override the
package's `backendCC` argument when changing that collection policy as well.
The invocation wrapper records the original `NVCC_CCBIN` input before
projecting its role-specific value or packaged default. A nested invocation
restores that input if the inherited projection is unchanged, allowing it to
select its own roles and default while preserving explicit caller overrides.
For legacy FindCUDA, `CUDA_BIN_PATH` defaults to the NVCC binary directory for
the HOST role, so a BUILD compiler appearing earlier on PATH does not replace it.
The component collector supplies compiler-discovery defaults when it registers
each executable compiler. NVCC's own setup hook normalizes structured flag
arrays and exports the compression setting; library-only dependencies do not
configure NVCC.

NVCC and NVVM retain one compiler prefix. The `outputBin` mapping locates its
executables, wrapper support, and compiler metadata; `outputInclude` and
`outputLib` still locate their respective contents. Aggregation outputs do not
publish a second compiler or assign its CUDA version to a different role.
`outputDev` defaults to `outputBin`, keeping activation and propagated TARGET
dependencies with that compiler metadata when another package forwards them
through its development output. An override separating those outputs must
retain that activation and dependency interface.

NVCC's TARGET component paths and CUDART's public header metadata follow the
components' declared `outputInclude`, `outputLib`, and `outputStubs` mappings.
When embedding a mapped component path, use
`lib.getOutput component.outputInclude component` (or the corresponding
library/stub selector). `lib.getInclude` follows conventional output names;
it does not interpret a custom `outputInclude` mapping.
Ordinary `buildInputs` selection uses `lib.getDev`, which chooses a literal
`dev` output or falls back to `out`; setting `outputDev` does not rename that
lookup. `buildRedist` propagates required component outputs through this input
interface and the declared development output. Keep output references acyclic:
an aggregate output cannot also depend on a development output that already
references its payload. Arbitrary remapping of activation and package metadata
still requires a coherent output layout.

`cudaPackages.saxpy` tests CMake's CUDA discovery, compilation, and linking.
`cudaPackages.tests.nvcc-roles` builds saxpy twice in one environment, using
different CUDA releases for BUILD and HOST, and checks both ELF machine types.
Run the resulting executables on their respective machines with a compatible
GPU and driver to check runtime behavior as well. Successful evaluation or
archive unpacking alone does not establish cross-compilation support.

Setup hooks are not automatically run when an installed application invokes
NVCC for JIT compilation. The executable wrapper supplies its packaged backend,
and its profile supplies the default TARGET CUDA runtime, CRT, and CCCL paths.
The profile initializes its component search paths for every invocation: NVCC exports
its computed `INCLUDES`, `SYSTEM_INCLUDES`, and `LIBRARIES` to subprocesses, which
must not make a nested compiler select another CUDA release. Supply additional paths
with `-I`/`-L` or `NVCC_PREPEND_FLAGS`/`NVCC_APPEND_FLAGS`; the internal profile
accumulators are not caller inputs. `PATH` and `LD_LIBRARY_PATH` retain the
caller's environment.
These defaults also work without stdenv activation. A JIT consumer must still
provide paths for additional dependencies, such as PyTorch's own headers and
libraries: propagated inputs do not reconstruct a runtime compilation environment.
Consumers such as `torch.utils.cpp_extension` also invoke a separate C++
compiler and linker. Those commands need CUDA component include and library
paths, either explicitly or through the aggregate prefix expected by their
`CUDA_HOME` interface; NVCC's profile only configures NVCC's own invocations.
PyTorch additionally turns `CC` into an explicit NVCC backend argument. Unset
`CC` for this caller to use NVCC's packaged default, or select a compatible
backend there while keeping the ordinary C++ compiler in `CXX`.
`cudaPackages.tests.nvcc-runtime` checks PTX, cubin, and shared-library compilation
in an empty environment without explicit CUDA include or library flags. It also
creates a separate device archive and links it through each of the three linker
flag variables, with no ambient compiler or archiver on PATH.
Native GNU tests also invoke NVCC from GCC and another NVCC to check that
inherited flag caches and projected backend defaults do not replace the
child invocation's role-specific inputs.
GNU tests also nest different CUDA releases, including during cross builds,
and check the child's CCCL header selection and linked CUDA runtime SONAME.

For NVCC with a Clang backend and glibc, `cuda_crt` maps the unsupported
`__builtin___vfprintf_chk` builtin to glibc's checked `__vfprintf_chk` entry
point before the fortified stdio definitions are parsed. The guard applies
only to that compiler/libc combination with fortify active; it does not lower
the fortify level. CUDA 12 additionally needs internal linkage for glibc's
Clang fortify overloads; its guarded header adjustment retains their object-size
attributes and checked bodies. These workarounds also apply to installed JIT
invocations. `tests.nvcc-fortify` requests hardening without setup activation,
compiles and links two translation units, and checks that buffer overflows and writable `%n` formats
still abort on executable platforms. Nixpkgs' existing Clang wrapper policy
selects fortify level 2; explicitly forcing level 3 still exposes additional
NVIDIA frontend incompatibilities and is not covered by this workaround.

Select a JIT compiler as a HOST→HOST dependency of the installed application;
select a compiler used during its build as a BUILD→HOST dependency. Splicing
selects these package instances; the wrapper and its profile make each instance
usable. A runtime wrapper cannot turn a BUILD executable into a HOST executable.
`cuda_cudart.tests.no-compiler` separately checks that installing the runtime
does not pull NVCC into its closure.

The deprecated merged `cudatoolkit` follows the same HOST→TARGET convention.
Build-time compiler users must put it (or preferably `cuda_nvcc`) in
`nativeBuildInputs`; it no longer forces BUILD executables into its runtime
package. Its compatibility `lib` output uses the same TARGET library selection
and participates in normal output splicing without retaining the HOST tools.
CUDA 12's bundled PTX compiler API is
extracted as `libnvptxcompiler`, as it is in CUDA 13, and selected for TARGET
when included in a compiler prefix. `tests.cudatoolkit` checks both CUDA
compilation and linking a CPU program against that API.

Applications must configure their runtime compiler dependencies explicitly.
For example, PyCUDA pins a HOST→HOST NVCC path and its additional cuRAND headers
and device-runtime library fallback in its installed Python code. Its JIT
compiler does not depend on setup hooks having run in the calling process.

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
