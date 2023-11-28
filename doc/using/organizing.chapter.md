# Organizing packages with callPackage {#chap-organizing}

You can use [`stdenv.mkDerivation`](#sec-using-stdenv) to build packages, but it quickly becomes cumbersome when managing more than a small handful of packages. Nixpkgs provides a number of tools to help build and manage large sets of packages which depend on each other or on the Nixpkgs package set.

## callPackage {#sec-callpackage}

`pkgs.callPackage` is a tool for filling function arguments with `pkgs` attributes. For instance, if you have a file `foo.nix`:

```nix
{
  stdenv,
  fetchurl,
  zlib,
}:
stdenv.mkDerivation {
  name = "libfoo-1.2.3";
  src = fetchurl {
    url = "http://example.org/libfoo-1.2.3.tar.bz2";
    hash = "sha256-tWxU/LANbQE32my+9AXyt3nCT7NBVfJ45CX757EMT3Q=";
  };
  nativeBuildInputs = [zlib];
}
```

Then `pkgs.callPackage ./foo.nix { }` is equivalent to `import ./foo.nix { inherit (pkgs) stdenv fetchurl zlib; }`. The second argument to `callPackage` can be used to override arguments or to specify extra arguments that aren't in Nixpkgs.

Nixpkgs itself is built from many packages in different files, combined together with `callPackage` invocations.

## makeScope {#sec-makescope}

When you're building up a package set, you'll typically want your packages to depend on each other, like these two packages:

```nix
# my-cool-library.nix
{
  stdenv,
}:
stdenv.mkDerivation {
  name = "my-cool-library-1.2.3";
  # ...
}
```

```nix
# my-cool-program.nix
{
  stdenv,
  my-cool-library,
}:
stdenv.mkDerivation {
  name = "my-cool-program-1.2.3";
  buildInputs = [my-cool-library];
  # ...
}
```

With `pkgs.callPackage`, we can compose a package set like this:

```nix
# The `rec` keyword is generally discouraged; read on for more.
rec {
  my-cool-library = pkgs.callPackage ./my-cool-library.nix { };
  my-cool-program = pkgs.callPackage ./my-cool-program.nix { inherit my-cool-library; };
}
```

This quickly becomes frustrating, so Nixpkgs provides a tool to extend `callPackage` with custom packages, [`lib.makeScope`](#function-library-lib.customisation.makeScope). A **scope** is a set of packages which can depend on each other.

We can rewrite the previous example with `makeScope` like this, replacing `pkgs.callPackage` with `self.callPackage`:

```nix
lib.makeScope pkgs.newScope (self: {
  my-cool-library = self.callPackage ./my-cool-library.nix { };
  my-cool-program = self.callPackage ./my-cool-program.nix { };
})
# {
#   my-cool-library = «derivation»;
#   my-cool-program = «derivation»;
#   newScope = «lambda»;
#   overrideScope = «lambda»;
#   packages = «lambda»;
#   callPackage = «lambda»;
# }
```

Because scopes are lazily evaluated, the package files can depend on each other by name.

::: {.note}
`pkgs.newScope` is used to construct the new scope's `callPackage` function. When `pkgs.newScope` is called with a set of extra arguments for `callPackage` to use, it returns a new [`callPackage` function](#sec-callpackage). `pkgs.newScope` is defined roughly like this:

```nix
newScope = extra: lib.callPackageWith (pkgs // extra)
```

The [`lib.extends`](#function-library-lib.fixedPoints.extends) fixed-point function is used to pass the newly constructed scope (`self`) to `newScope` while making the `callPackage` function produced by `newScope` available in `self` when the scope is being constructed.
:::
