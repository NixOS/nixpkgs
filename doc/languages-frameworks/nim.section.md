# Nim {#nim}

The Nim compiler and a builder function is available.
Nim programs are built using `buildNimPackage` and a lockfile containing Nim dependencies.

The following example shows a Nim program that depends only on Nim libraries:
```nix
{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage { } (finalAttrs: {
  pname = "ttop";
  version = "1.2.7";

  src = fetchFromGitHub {
    owner = "inv2004";
    repo = "ttop";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oPdaUqh6eN1X5kAYVvevOndkB/xnQng9QVLX9bu5P5E=";
  };

  lockFile = ./lock.json;

  nimFlags = [
    "-d:NimblePkgVersion=${finalAttrs.version}"
  ];
})
```

## `buildNimPackage` parameters {#buildnimpackage-parameters}

The `buildNimPackage` function takes an attrset of parameters that are passed on to `stdenv.mkDerivation`.

The following parameters are specific to `buildNimPackage`:

* `lockFile`: JSON formatted lockfile.
* `nimbleFile`: Specify the Nimble file location of the package being built
  rather than discover the file at build-time.
* `nimRelease ? true`: Build the package in *release* mode.
* `nimDefines ? []`: A list of Nim defines. Key-value tuples are not supported.
* `nimFlags ? []`: A list of command line arguments to pass to the Nim compiler.
  Use this to specify defines with arguments in the form of `-d:${name}=${value}`.
* `nimDoc` ? false`: Build and install HTML documentation.

## Lockfiles {#nim-lockfiles}
Nim lockfiles are created with the `nim_lk` utility.
Run `nim_lk` with the source directory as an argument and it will print a lockfile to stdout.
```sh
$ cd nixpkgs
$ nix build -f . ttop.src
$ nix run -f . nim_lk ./result | jq --sort-keys > pkgs/by-name/tt/ttop/lock.json
```

## Overriding Nim packages {#nim-overrides}

The `buildNimPackage` function generates flags and additional build dependencies from the `lockFile` parameter passed to `buildNimPackage`. Using [`overrideAttrs`](#sec-pkg-overrideAttrs) on the final package will apply after this has already been generated, so this can't be used to override the `lockFile` in a package built with `buildNimPackage`. To be able to override parameters before flags and build dependencies are generated from the `lockFile`, use `overrideNimAttrs` instead with the same syntax as `overrideAttrs`:

```nix
pkgs.nitter.overrideNimAttrs {
  # using a different source which has different dependencies from the standard package
  src = pkgs.fetchFromGithub { /* … */ };
  # new lock file generated from the source
  lockFile = ./custom-lock.json;
}
```

## Lockfile dependency overrides {#nim-lock-overrides}

The `buildNimPackage` function matches the libraries specified by `lockFile` to attrset of override functions that are then applied to the package derivation.
The default overrides are maintained as the top-level `nimOverrides` attrset at `pkgs/top-level/nim-overrides.nix`.

For example, to propagate a dependency on SDL2 for lockfiles that select the Nim `sdl2` library, an overlay is added to the set in the `nim-overrides.nix` file:
```nix
{ lib
/* … */
, SDL2
/* … */
}:

{
  /* … */
  sdl2 =
    lockAttrs:
    finalAttrs:
    { buildInputs ? [ ], ... }:
    {
      buildInputs = buildInputs ++ [ SDL2 ];
    };
  /* … */
}
```

The annotations in the `nim-overrides.nix` set are functions that take three arguments and return a new attrset to be overlayed on the package being built.
- lockAttrs: the attrset for this library from within a lockfile. This can be used to implement library version constraints, such as marking libraries as broken or insecure.
- finalAttrs: the final attrset passed by `buildNimPackage` to `stdenv.mkDerivation`.
- prevAttrs: the attrset produced by initial arguments to `buildNimPackage` and any preceding lockfile overlays.

### Overriding an Nim library override {#nim-lock-overrides-overrides}

The `nimOverrides` attrset makes it possible to modify overrides in a few different ways.

Override a package internal to its definition:
```nix
{ lib, buildNimPackage, nimOverrides, libressl }:

let
  buildNimPackage' = buildNimPackage.override {
    nimOverrides = nimOverrides.override { openssl = libressl; };
  };
in buildNimPackage' (finalAttrs: {
  pname = "foo";
  # …
})

```

Override a package externally:
```nix
{ pkgs }: {
  foo = pkgs.foo.override {
    buildNimPackage = pkgs.buildNimPackage.override {
      nimOverrides = pkgs.nimOverrides.override { openssl = libressl; };
    };
  };
}
```
