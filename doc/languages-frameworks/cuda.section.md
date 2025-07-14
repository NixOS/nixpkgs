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
{
  config,
  cudaSupport ? config.cudaSupport,
  cudaPackages ? { },
  ...
}:
{ }
```

When using `callPackage`, you can choose to pass in a different variant, e.g.
when a different version of the toolkit suffices
```nix
{
  mypkg = callPackage { cudaPackages = cudaPackages_11_5; };
}
```

If another version of say `cudnn` or `cutensor` is needed, you can override the
package set to make it the default. This guarantees you get a consistent package
set.
```nix
{
  mypkg =
    let
      cudaPackages = cudaPackages_11_5.overrideScope (
        final: prev: {
          cudnn = prev.cudnn_8_3;
        }
      );
    in
    callPackage { inherit cudaPackages; };
}
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

## Running Docker or Podman containers with CUDA support {#cuda-docker-podman}

It is possible to run Docker or Podman containers with CUDA support. The recommended mechanism to perform this task is to use the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/index.html).

The NVIDIA Container Toolkit can be enabled in NixOS like follows:

```nix
{
  hardware.nvidia-container-toolkit.enable = true;
}
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

### Specifying what devices to expose to the container {#cuda-specifying-what-devices-to-expose-to-the-container}

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

### Using docker-compose {#cuda-using-docker-compose}

It's possible to expose GPU's to a `docker-compose` environment as well. With a `docker-compose.yaml` file like follows:

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
