# Nim {#nim}

## Overview {#nim-overview}

The Nim compiler, a builder function, and some packaged libraries are available
in Nixpkgs. Until now each compiler release has been effectively backwards
compatible so only the latest version is available.

## Nim program packages in Nixpkgs {#nim-program-packages-in-nixpkgs}

Nim programs can be built using `nimPackages.buildNimPackage`. In the
case of packages not containing exported library code the attribute
`nimBinOnly` should be set to `true`.

The following example shows a Nim program that depends only on Nim libraries:

```nix
{ lib, nimPackages, fetchurl }:

nimPackages.buildNimPackage rec {
  pname = "hottext";
  version = "1.4";

  nimBinOnly = true;

  src = fetchurl {
    url = "https://git.sr.ht/~ehmry/hottext/archive/v${version}.tar.gz";
    hash = "sha256-hIUofi81zowSMbt1lUsxCnVzfJGN3FEiTtN8CEFpwzY=";
  };

  buildInputs = with nimPackages; [
    bumpy
    chroma
    flatty
    nimsimd
    pixie
    sdl2
    typography
    vmath
    zippy
  ];
}

```

## Nim library packages in Nixpkgs {#nim-library-packages-in-nixpkgs}


Nim libraries can also be built using `nimPackages.buildNimPackage`, but
often the product of a fetcher is sufficient to satisfy a dependency.
The `fetchgit`, `fetchFromGitHub`, and `fetchNimble` functions yield an
output that can be discovered during the `configurePhase` of `buildNimPackage`.

Nim library packages are listed in
[pkgs/top-level/nim-packages.nix](https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/nim-packages.nix) and implemented at
[pkgs/development/nim-packages](https://github.com/NixOS/nixpkgs/tree/master/pkgs/development/nim-packages).

The following example shows a Nim library that propagates a dependency on a
non-Nim package:
```nix
{ lib, buildNimPackage, fetchNimble, SDL2 }:

buildNimPackage rec {
  pname = "sdl2";
  version = "2.0.4";
  src = fetchNimble {
    inherit pname version;
    hash = "sha256-qDtVSnf+7rTq36WAxgsUZ8XoUk4sKwHyt8EJcY5WP+o=";
  };
  propagatedBuildInputs = [ SDL2 ];
}
```

## `buildNimPackage` parameters {#buildnimpackage-parameters}

All parameters from `stdenv.mkDerivation` function are still supported. The
following are specific to `buildNimPackage`:

* `nimBinOnly ? false`: If `true` then build only the programs listed in
  the Nimble file in the packages sources.
* `nimbleFile`: Specify the Nimble file location of the package being built
  rather than discover the file at build-time.
* `nimRelease ? true`: Build the package in *release* mode.
* `nimDefines ? []`: A list of Nim defines. Key-value tuples are not supported.
* `nimFlags ? []`: A list of command line arguments to pass to the Nim compiler.
  Use this to specify defines with arguments in the form of `-d:${name}=${value}`.
* `nimDoc` ? false`: Build and install HTML documentation.

* `buildInputs` ? []: The packages listed here will be searched for `*.nimble`
  files which are used to populate the Nim library path. Otherwise the standard
  behavior is in effect.
