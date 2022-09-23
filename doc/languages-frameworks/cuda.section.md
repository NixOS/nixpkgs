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
