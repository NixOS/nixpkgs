# Zig {#zig}

## Overview {#zig-overview}

The Zig compiler and a builder function are available in Nixpkgs.

## Zig program packages in Nixpkgs {#zig-program-packages-in-nixpkgs}

Zig programs can be built using `buildZigPackage`. This builder function is available under any Zig compiler version.

The following example shows a Zig program. It uses Zig 0.9.
`buildZigPackage` *always* uses `-Drelease-safe -Dcpu=baseline` flags.

```nix
{ lib, fetchFromGitHub, zig_0_9 }:

zig_0_9.buildZigPackage rec {
  pname = "colorstorm";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "benbusby";
    repo = "colorstorm";
    rev = "v${version}";
    hash = "sha256-6+P+QQpP1jxsydqhVrZkjl1gaqNcx4kS2994hOBhtu8=";
  };
}
```

## `buildZigPackage` parameters {#buildzigpackage-parameters}

All parameters from `stdenv.mkDerivation` function are still supported. The
following are specific to `buildZigPackage`:

* `zigBuildFlags`: A list of strings holding the build flags passed to Zig compiler. By default it is empty.
