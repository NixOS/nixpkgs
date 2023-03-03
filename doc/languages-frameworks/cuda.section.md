# CUDA {#cuda}

CUDA-only packages are stored in the `cudaPackages` packages set. This set
includes the `cudatoolkit`, portions of the toolkit in separate derivations,
`cudnn`, `cutensor` and `nccl`.

A package set is available for each CUDA version, so for example
`cudaPackages_11_6`. Within each set is a matching version of the above listed
packages. Additionally, other versions of the packages that are packaged and
compatible are available as well. For example, there can be a
`cudaPackages.cudnn_8_3_2` package.

To use one or more CUDA packages in an expression, give the expression a `cudaPackages` parameter, and in case CUDA is optional
```nix
cudaSupport ? false
cudaPackages ? {}
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
  cudaPackages = cudaPackages_11_5.overrideScope' (final: prev {
    cudnn = prev.cudnn_8_3_2;
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
