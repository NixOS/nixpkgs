# Julia {#language-julia}

## Introduction {#julia-introduction}

Nixpkgs includes Julia as the `julia` derivation.
You can get specific versions by looking at the other `julia*` top-level derivations available.
For example, `julia_19` corresponds to Julia 1.9.
We also provide the current stable version as `julia-stable`, and an LTS version as `julia-lts`.

Occasionally, a Julia version has been too difficult to build from source in Nixpkgs and has been fetched prebuilt instead.
These Julia versions are differentiated with the `*-bin` suffix; for example, `julia-stable-bin`.

## julia.withPackages {#julia-withpackage}

The basic Julia derivations only provide the built-in packages that come with the distribution.

You can build Julia environments with additional packages using the `julia.withPackages` command.
This function accepts a list of strings representing Julia package names.
For example, you can build a Julia environment with the `Plots` package as follows.

```nix
julia.withPackages ["Plots"]
```

Arguments can be passed using `.override`.
For example:

```nix
(julia.withPackages.override {
  precompile = false; # Turn off precompilation
}) ["Plots"]
```

Here's a nice way to run a Julia environment with a shell one-liner:

```sh
nix-shell -p 'julia.withPackages ["Plots"]' --run julia
```

### Arguments {#julia-withpackage-arguments}

* `precompile`: Whether to run `Pkg.precompile()` on the generated environment.

  This will make package imports faster, but may fail in some cases.
  For example, there is an upstream issue with `Gtk.jl` that prevents precompilation from working in the Nix build sandbox, because the precompiled code tries to access a display.
  Packages like this will work fine if you build with `precompile=false`, and then precompile as needed once your environment starts.

  Defaults: `true`

* `extraLibs`: Extra library dependencies that will be placed on the `LD_LIBRARY_PATH` for Julia.

  Should not be needed as we try to obtain library dependencies automatically using Julia's artifacts system.

* `makeWrapperArgs`: Extra arguments to pass to the `makeWrapper` call which we use to wrap the Julia binary.
* `setDefaultDepot`: Whether to automatically prepend `$HOME/.julia` to the `JULIA_DEPOT_PATH`.

  This is useful because Julia expects a writable depot path as the first entry, which the one we build in Nixpkgs is not.
  If there's no writable depot, then Julia will show a warning and be unable to save command history logs etc.

  Default: `true`

* `packageOverrides`: Allows you to override packages by name by passing an alternative source.

  For example, you can use a custom version of the `LanguageServer` package by passing `packageOverrides = { "LanguageServer" = fetchFromGitHub {...}; }`.

* `augmentedRegistry`: Allows you to change the registry from which Julia packages are drawn.

  This normally points at a special augmented version of the Julia [General packages registry](https://github.com/JuliaRegistries/General).
  If you want to use a bleeding-edge version to pick up the latest package updates, you can plug in a later revision than the one in Nixpkgs.
