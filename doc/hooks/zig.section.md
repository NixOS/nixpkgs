# zig.hook {#zig-hook}

[Zig](https://ziglang.org/) is a general-purpose programming language and toolchain for maintaining robust, optimal and reusable software.

In Nixpkgs, `zig.hook` overrides the default build, check and install phases.

## Example code snippet {#example-code-snippet}

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

## Variables controlling zig.hook {#variables-controlling-zig-hook}

### `zig.hook` Exclusive Variables {#zigHookExclusiveVariables}

The variables below are exclusive to `zig.hook`.

#### `dontUseZigBuild` {#dontUseZigBuild}

Disables using `zigBuildPhase`.

#### `dontUseZigCheck` {#dontUseZigCheck}

Disables using `zigCheckPhase`.

#### `dontUseZigInstall` {#dontUseZigInstall}

Disables using `zigInstallPhase`.

### Similar variables {#similarVariables}

The following variables are similar to their `stdenv.mkDerivation` counterparts.

| `zig.hook` Variable | `stdenv.mkDerivation` Counterpart |
|---------------------|-----------------------------------|
| `zigBuildFlags`     | `buildFlags`                      |
| `zigCheckFlags`     | `checkFlags`                      |
| `zigInstallFlags`   | `installFlags`                    |

### Variables honored by zig.hook {#variables-honored-by-zig-hook}

The following variables commonly used by `stdenv.mkDerivation` are honored by `zig.hook`.

- `prefixKey`
- `dontAddPrefix`
