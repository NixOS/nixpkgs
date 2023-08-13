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

### `dontUseZigBuild` {#dontUseZigBuild}

Disables using `zigBuildPhase`.

### `zigBuildFlags` {#zigBuildFlags}

Controls the flags passed to the build phase.

### `dontUseZigCheck` {#dontUseZigCheck}

Disables using `zigCheckPhase`.

### `zigCheckFlags` {#zigCheckFlags}

Controls the flags passed to the check phase.

### `dontUseZigInstall` {#dontUseZigInstall}

Disables using `zigInstallPhase`.

### `zigInstallFlags` {#zigInstallFlags}

Controls the flags passed to the install phase.

### Variables honored by zig.hook {#variables-honored-by-zig-hook}

- `prefixKey`
- `dontAddPrefix`
