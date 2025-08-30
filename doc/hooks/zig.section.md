# Zig {#zig}

[Zig](https://ziglang.org/) is a general-purpose programming language and toolchain for maintaining robust, optimal and reusable software.

In Nixpkgs, `zig` overrides the default build, check and install phases.

## Example code snippet {#zig-example-code-snippet}

```nix
{
  lib,
  stdenv,
  zig,
}:

stdenv.mkDerivation (finalAttrs: {
  # . . .

  nativeBuildInputs = [ zig ];

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  zigBuildFlags = [ "-Dman-pages=true" ];

  dontUseZigCheck = true;

  # . . .
})
```

## Dependencies {#zig-dependencies}

When packaging Zig applications, use the `fetchDeps` function that is available
in the Zig compiler package, and set the `zigDeps` attribute to its result.

Zig lazy dependencies are fetched at build time, and this is forbidden behavior
inside of Nix. Zig versions >= 0.15.1 can deal with this properly, but versions
before 0.15.1 may not fetch all lazy dependencies properly.

To work around this, specify `manuallyFetchLazyDeps = true;` as an argument to
`fetchDeps`. This may not work in all cases, such as when lazy dependencies rely
on differing Zig versions. Updating the upstream Zig version to use a version
past 0.15.1 can fix this issue.

## Variables controlling zig {#zig-variables-controlling}

### `zig` Exclusive Variables {#zig-exclusive-variables}

The variables below are exclusive to `zig`.

#### `dontUseZigConfigure` {#dont-use-zig-configure}

Disables using `zigConfigurePhase`.

#### `dontUseZigBuild` {#dont-use-zig-build}

Disables using `zigBuildPhase`.

#### `dontUseZigCheck` {#dont-use-zig-check}

Disables using `zigCheckPhase`.

#### `dontUseZigInstall` {#dont-use-zig-install}

Disables using `zigInstallPhase`.

#### `dontSetZigDefaultFlags` {#dont-set-zig-default-flags}

Disables using a set of default flags when performing zig builds.

### Similar variables {#zig-similar-variables}

The following variables are similar to their `stdenv.mkDerivation` counterparts.

| `zig` Variable | `stdenv.mkDerivation` Counterpart |
|---------------------|-----------------------------------|
| `zigBuildFlags`     | `buildFlags`                      |
| `zigCheckFlags`     | `checkFlags`                      |
| `zigInstallFlags`   | `installFlags`                    |

### Variables honored by zig {#zig-variables-honored}

The following variables commonly used by `stdenv.mkDerivation` are honored by `zig`.

- `prefixKey`
- `dontAddPrefix`
