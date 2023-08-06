# zigHook {#zighook}

[Zig](https://ziglang.org/) is a general-purpose programming language and toolchain for maintaining robust, optimal and reusable software.

In Nixpkgs, `zigHook` overrides the default build, check and install phases.

## Example code snippet {#example-code-snippet}

```nix
{ lib
, stdenv
, zigHook
}:

stdenv.mkDerivation {
  # . . .

  nativeBuildInputs = [
    zigHook
  ];

  zigBuildFlags = [ "-Dman-pages=true" ];

  dontUseZigCheck = true;

  # . . .
}
```

## Variables controlling zigHook {#variables-controlling-zighook}

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

### Variables honored by zigHook {#variablesHonoredByZigHook}

- `prefixKey`
- `dontAddPrefix`
