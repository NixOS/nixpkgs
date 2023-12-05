# Fixed-point arguments of build helpers {#chap-build-helpers-finalAttrs}

As mentioned in the beginning of this part, `stdenv.mkDerivation` could alternatively accept a fixed-point function. The input of such function, typically named `finalAttrs`, is expected to be the final state of the attribute set.
A build helper like this is said to accept **fixed-point arguments**.

As [`stdenv.mkDerivation`'s support of fixed-point arguments](#mkderivation-recursive-attributes) was first included in the Nixpkgs release 22.05, `mkDerivation`-style build helpers don't always come with such support yet.

## Defining a build helper with `lib.extendMkDerivation` {#sec-build-helper-extendMkDerivation}

The Nixpkgs library function [`lib.customisation.extendMkDerivation`](#function-library-lib.customisation.extendMkDerivation) can be used to define a build helper supporting fixed-point arguments from an existing one with such support. It can also bring fixed-point argument support to existing builders as a wrapper around the original definition.

The following is the conventional definition of build helper `mkLocalDerivation` that doesn't support fixed-point arguments:

:::{.example #ex-build-helpers-mkLocalDerivation-plain}

# Example definition of `mkLocalDerivation` without fixed-point arguments support

Write the followings in `pkgs/path/to/local-derivation/default.nix`:

```nix
{ lib
, stdenv
}:

{ preferLocalBuild ? true
, allowSubstitute ? false
, impassablePredicate ? (_: false)
, ...
}@args:

stdenv.mkDerivation (removeAttrs args [
  "impassablePredicate"
] // {
  inherit
    preferLocalBuild
    allowSubstitute
    ;
})
```

and call the definition in [`all-packages.nix`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/all-packages.nix):

```nix
{
  mkLocalDerivation = callPackage ../path/to/local-derivation { };
}
```

:::

A wrapper of `lib.extendMkDerivation` around the original definition brings the magical `finalAttrs` to the builder:

:::{.example #ex-build-helpers-mkLocalDerivation-extendMkDerivation}

# Example definition of `mkLocalDerivation` extended from `stdenv.mkDerivation` with `lib.extendMkDerivation`

Write in `pkgs/path/to/local-derivation/default.nix`:

```nix
{ lib
, stdenv
}:

lib.extendMkDerivation stdenv.mkDerivation (finalAttrs:

{ preferLocalBuild ? true
, allowSubstitute ? false
, impassablePredicate ? (_: false)
, ...
}@args:

removeAttrs args [
  "impassablePredicate"
] // {
  inherit
    preferLocalBuild
    allowSubstitute
    ;
})
```

and call it the same way in `all-packages.nix`.
:::

Should there be a need to modify the result derivation, `lib.customisation.extendMkDerivationModified` additionally takes a derivation modification function as the first argument. See the definition of `buildPythonModule`/`buildPythonApplication` in `pkgs/development/interpreters/python/mk-python-derivation.nix` for practical use cases.

Extending a build helper with `lib.extendMkDerivation` is different from extending the fixed-point arguments with `lib.extend` or [`<pkg>.overrideAttrs`](#sec-pkg-overrideAttrs), as the implementation can choose *not* to pass some input arguments (e.g. `impassablePredicate`) down the base build helper instead of having to pass everything like a conventional overriding/overlay.

Ideally, every attributes could be passed properly through `passthru`, and then we only need `overrideAttrs` and package-level overlays. Nevertheless, a lot of existing builders does have some "impassable" arguments. `lib.extendMkDerivation` simplifies the migration toward fixed-point arguments, and let the community decide on future directions.
