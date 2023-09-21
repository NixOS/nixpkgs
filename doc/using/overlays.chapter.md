# Overlays {#chap-overlays}

This chapter describes how to extend and change Nixpkgs using overlays.

TODO: Maybe add link to `lib.extends`/`lib.fix`

## What are overlays {#sec-overlays-definition}

Overlays are Nix functions which accept two arguments, conventionally called `self` and `super`, and return a set of attributes. For example, the following is a valid overlay.

```nix
self: super:

{
  boost = super.boost.override {
    python = self.python3;
  };
  rr = super.callPackage ./pkgs/rr {
    stdenv = self.stdenv_32bit;
  };
}
```

The first argument (`self`) corresponds to the final package set. You should use this set for the dependencies of all packages specified in your overlay. For example, all the dependencies of `rr` in the example above come from `self`, as well as the overridden dependencies used in the `boost` override.

The second argument (`super`) corresponds to the result of the evaluation of the previous stages of Nixpkgs. It does not contain any of the packages added by the current overlay, nor any of the following overlays. This set should be used either to refer to packages you wish to override, or to access functions defined in Nixpkgs. For example, the original recipe of `boost` in the above example, comes from `super`, as well as the `callPackage` function.

The value returned by this function should be a set similar to `pkgs/top-level/all-packages.nix`, containing overridden and/or new packages.

Overlays are similar to other methods for customizing Nixpkgs, in particular the `packageOverrides` attribute described in [](#sec-modify-via-packageOverrides). Indeed, `packageOverrides` acts as an overlay with only the `super` argument. It is therefore appropriate for basic use, but overlays are more powerful and easier to distribute.

Note that the order of the overlays can matter if multiple overlays set the same attributes.

## Applying overlays {#sec-overlays-applying}

In order to define overlays, you need to know where to put them so they get applied.
See [here](#sec-overlays-definition) for how to define overlays.

There are various ways of applying overlays, but by default none are applied.

### Using nix expression {#d}

#### Applying overlays when importing Nixpkgs {#sec-overlays-applying-nixpkgs}

When importing Nixpkgs, a list of overlays can be specified using the `overlays` attribute in the argument:
```nix
pkgs = import <nixpkgs> {
  overlays = [
    firstOverlay
    secondOverlay
  ];
}
```

If the `overlays` argument is not passed, these defaults are used:

- If the [path expression](https://nixos.org/manual/nix/stable/language/values#type-path) `<nixpkgs-overlays>` points to an existing path, we look for overlays there, as described in [the below section](#sec-overlays-applying-nixpkgs-paths).

  Where such path expressions point is defined with the [`NIX_PATH`](https://nixos.org/manual/nix/stable/command-ref/env-common.html#env-NIX_PATH) environment variable.

  On a NixOS system, this variable can be set using the [`nix.nixPath` option](https://search.nixos.org/options?show=nix.nixPath&query=nix.nixPath).
  On non-NixOS systems, see [here](https://wiki.archlinux.org/title/Environment_variables) for how to set environment variables.

- If either `~/.config/nixpkgs/overlays.nix` or `~/.config/nixpkgs/overlays/` exist, then we look for overlays at that path, as described in [the below section](#sec-overlays-applying-nixpkgs-paths).
  It is an error if both exist.

##### How paths get turned into overlays {#sec-overlays-applying-nixpkgs-paths}

- If the path is a file, then the file is imported as a Nix expression and used as the list of overlays.
  Here is an example:
  ```nix
  # overlays.nix
  [
    # first overlay
    (final: prev: { ... })

    # second overlay
    (final: prev: { ... })
  ]
  ```

- If the path is a directory, then we take the entries of the directory, order them alphabetically, and attempt to interpret each as an overlay by:

  - Importing the file, if it is a `.nix` file.

  - Importing a top-level `default.nix` file, if it is a directory.

  Here's an example of a suitable directory structure:
  ```
  overlays
  ├── 50-firstOverlay.nix
  └── 60-secondOverlay
     └── default.nix
  ```

#### Applying further overlays on top of an imported Nixpkgs {#c}

If you already have an imported Nixpkgs (often in a variable called `pkgs`),
you can apply a list of overlays on top using `pkgs.appendOverlays`:

```nix
pkgsModified = pkgs.appendOverlays [
  firstAdditionalOverlay
  secondAdditionalOverlay
]
```

Or just a single overlay using `pkgs.extend`:
```nix
pkgsModified = pkgs.extend additionalOverlay
```

Both the overlays of original `pkgs` and the new ones will be applied, in this order.

:::{.warning}
The `pkgsModified` result cannot re-use any values already computed for the `pkgs` values,
so these functions may be expensive.

This should not be used in Nixpkgs.
:::

### Commands implicitly importing Nixpkgs {#b}

These CLI commands can implicitly import Nixpkgs without it being specified in a Nix expression.

#### `nixos-rebuild` {#e}

NixOS implicitly imports Nixpkgs for you [with the `overlays` argument](#sec-overlays-applying-nixpkgs) set to the value of the [`nixpkgs.overlays`](https://search.nixos.org/options?show=nixpkgs.overlays&query=nixpkgs.overlays) option.

This option is empty by default.

This is the only thing that the `nixpkgs.overlays` option affects.
It does not propagate the overlays to the non-NixOS commands.

Note that this does not affect the overlays for non-NixOS operations (e.g.  `nix-env`), which are looked up independently, see the following sections.

#### `nix-shell -p` {#f}

`nix-shell -p` implicitly imports Nixpkgs without any arguments, such that the defaults from <link section> apply.

#### `nix-build '<nixpkgs>'` / `nix-env -f '<nixpkgs>'` {#g}

`nix-build` and `nix-env -f` with any Nixpkgs path, such as `<nixpkgs>` or `~/src/nixpkgs`, ...

Will by default pass no arguments to the Nixpkgs imports, therefore the defaults from <link section> apply.

The `overlays` argument can be overridden using the [`--arg`](<link to Nix manual>) option, for example to not use the default overlays:
```
nix-build '<nixpkgs>' --arg overlays '[ ]'
nix-env -f '<nixpkgs>' --arg overlays '[ ]'
```

## Sharing overlays between a NixOS configuration and nix commands {#a}

TODO: Rewrite
Because overlays that are set in NixOS configuration do not affect non-NixOS operations such as `nix-env`, the `overlays.nix` option provides a convenient way to use the same overlays for a NixOS system configuration and user configuration: the same file can be used as `overlays.nix` and imported as the value of `nixpkgs.overlays`.

```nix
# configuration.nix

nixpkgs.overlays = import ~/.config/nixpkgs/overlays.nix;
```


## Using overlays to configure alternatives {#sec-overlays-alternatives}

Certain software packages have different implementations of the same interface. Other distributions have functionality to switch between these. For example, Debian provides [DebianAlternatives](https://wiki.debian.org/DebianAlternatives).  Nixpkgs has what we call `alternatives`, which are configured through overlays.

### BLAS/LAPACK {#sec-overlays-alternatives-blas-lapack}

In Nixpkgs, we have multiple implementations of the BLAS/LAPACK numerical linear algebra interfaces. They are:

-   [OpenBLAS](https://www.openblas.net/)

    The Nixpkgs attribute is `openblas` for ILP64 (integer width = 64 bits) and `openblasCompat` for LP64 (integer width = 32 bits).  `openblasCompat` is the default.

-   [LAPACK reference](http://www.netlib.org/lapack/) (also provides BLAS and CBLAS)

    The Nixpkgs attribute is `lapack-reference`.

-   [Intel MKL](https://software.intel.com/en-us/mkl) (only works on the x86_64 architecture, unfree)

    The Nixpkgs attribute is `mkl`.

-   [BLIS](https://github.com/flame/blis)

    BLIS, available through the attribute `blis`, is a framework for linear algebra kernels. In addition, it implements the BLAS interface.

-   [AMD BLIS/LIBFLAME](https://developer.amd.com/amd-aocl/blas-library/) (optimized for modern AMD x86_64 CPUs)

    The AMD fork of the BLIS library, with attribute `amd-blis`, extends BLIS with optimizations for modern AMD CPUs. The changes are usually submitted to the upstream BLIS project after some time. However, AMD BLIS typically provides some performance improvements on AMD Zen CPUs. The complementary AMD LIBFLAME library, with attribute `amd-libflame`, provides a LAPACK implementation.

Introduced in [PR #83888](https://github.com/NixOS/nixpkgs/pull/83888), we are able to override the `blas` and `lapack` packages to use different implementations, through the `blasProvider` and `lapackProvider` argument. This can be used to select a different provider. BLAS providers will have symlinks in `$out/lib/libblas.so.3` and `$out/lib/libcblas.so.3` to their respective BLAS libraries.  Likewise, LAPACK providers will have symlinks in `$out/lib/liblapack.so.3` and `$out/lib/liblapacke.so.3` to their respective LAPACK libraries. For example, Intel MKL is both a BLAS and LAPACK provider. An overlay can be created to use Intel MKL that looks like:

```nix
self: super:

{
  blas = super.blas.override {
    blasProvider = self.mkl;
  };

  lapack = super.lapack.override {
    lapackProvider = self.mkl;
  };
}
```

This overlay uses Intel's MKL library for both BLAS and LAPACK interfaces. Note that the same can be accomplished at runtime using `LD_LIBRARY_PATH` of `libblas.so.3` and `liblapack.so.3`. For instance:

```ShellSession
$ LD_LIBRARY_PATH=$(nix-build -A mkl)/lib${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH nix-shell -p octave --run octave
```

Intel MKL requires an `openmp` implementation when running with multiple processors. By default, `mkl` will use Intel's `iomp` implementation if no other is specified, but this is a runtime-only dependency and binary compatible with the LLVM implementation. To use that one instead, Intel recommends users set it with `LD_PRELOAD`. Note that `mkl` is only available on `x86_64-linux` and `x86_64-darwin`. Moreover, Hydra is not building and distributing pre-compiled binaries using it.

To override `blas` and `lapack` with its reference implementations (i.e. for development purposes), one can use the following overlay:

```nix
self: super:

{
  blas = super.blas.override {
    blasProvider = self.lapack-reference;
  };

  lapack = super.lapack.override {
    lapackProvider = self.lapack-reference;
  };
}
```

For BLAS/LAPACK switching to work correctly, all packages must depend on `blas` or `lapack`. This ensures that only one BLAS/LAPACK library is used at one time. There are two versions of BLAS/LAPACK currently in the wild, `LP64` (integer size = 32 bits) and `ILP64` (integer size = 64 bits). The attributes `blas` and `lapack` are `LP64` by default. Their `ILP64` version are provided through the attributes `blas-ilp64` and `lapack-ilp64`. Some software needs special flags or patches to work with `ILP64`. You can check if `ILP64` is used in Nixpkgs with `blas.isILP64` and `lapack.isILP64`. Some software does NOT work with `ILP64`, and derivations need to specify an assertion to prevent this. You can prevent `ILP64` from being used with the following:

```nix
{ stdenv, blas, lapack, ... }:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation {
  ...
}
```

### Switching the MPI implementation {#sec-overlays-alternatives-mpi}

All programs that are built with [MPI](https://en.wikipedia.org/wiki/Message_Passing_Interface) support use the generic attribute `mpi` as an input. At the moment Nixpkgs natively provides two different MPI implementations:

-   [Open MPI](https://www.open-mpi.org/) (default), attribute name
    `openmpi`

-   [MPICH](https://www.mpich.org/), attribute name `mpich`

-   [MVAPICH](https://mvapich.cse.ohio-state.edu/), attribute name `mvapich`

To provide MPI enabled applications that use `MPICH`, instead of the default `Open MPI`, simply use the following overlay:

```nix
self: super:

{
  mpi = self.mpich;
}
```
