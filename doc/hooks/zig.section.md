# zig.hook {#zig-hook}

[Zig](https://ziglang.org/) is a general-purpose programming language and toolchain for maintaining robust, optimal and reusable software.

In Nixpkgs, `zig.hook` overrides the default build, check and install phases.

## Example code snippet {#zig-hook-example-code-snippet}

```nix
{ lib
, stdenv
, zig_0_11
}:

stdenv.mkDerivation {
  # . . .

  nativeBuildInputs = [
    zig_0_11.hook
  ];

  zigBuildFlags = [ "-Dman-pages=true" ];

  dontUseZigCheck = true;

  # . . .
}
```

## Variables controlling zig.hook {#zig-hook-variables-controlling}

### `zig.hook` Exclusive Variables {#zig-hook-exclusive-variables}

The variables below are exclusive to `zig.hook`.

#### `dontUseZigBuild` {#dont-use-zig-build}

Disables using `zigBuildPhase`.

#### `dontUseZigCheck` {#dont-use-zig-check}

Disables using `zigCheckPhase`.

#### `dontUseZigInstall` {#dont-use-zig-install}

Disables using `zigInstallPhase`.

### Similar variables {#zig-hook-similar-variables}

The following variables are similar to their `stdenv.mkDerivation` counterparts.

| `zig.hook` Variable | `stdenv.mkDerivation` Counterpart |
|---------------------|-----------------------------------|
| `zigBuildFlags`     | `buildFlags`                      |
| `zigCheckFlags`     | `checkFlags`                      |
| `zigInstallFlags`   | `installFlags`                    |

### Variables honored by zig.hook {#zig-hook-variables-honored}

The following variables commonly used by `stdenv.mkDerivation` are honored by `zig.hook`.

- `prefixKey`
- `dontAddPrefix`
