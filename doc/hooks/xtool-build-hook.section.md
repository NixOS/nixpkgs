# `xtoolBuildHook` {#xtool-build-hook}

Build iOS apps from SwiftPM packages with [xtool](https://xtool.sh).
It links the Darwin SDK from `xtool.sdk` into the build environment, runs {command}`xtool dev build`, and copies the resulting `.app` (or `.ipa`) into `$out`.

The hook only works on Linux.
The SDK needs Xcode, which must be added to the Nix store manually.

The hook provides Swift, so only `swiftpm` needs to be added.
List `xtoolBuildHook` before `swiftpm` in `nativeBuildInputs`, since the SwiftPM hook would otherwise set the build and install phases.

## Example {#xtool-build-hook-example}

:::{.example #xtool-build-hook-example-snippet}

# Building an iOS app with `xtoolBuildHook`

```nix
{
  stdenv,
  fetchFromGitHub,
  fetchSwiftPMDeps,
  swiftpm,
  xtoolBuildHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "some-ios-app";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "JohnSwift";
    repo = "SomeApp";
    tag = finalAttrs.version;
    hash = "...";
  };

  swiftpmDeps = fetchSwiftPMDeps {
    inherit (finalAttrs) pname version src;
    hash = "...";
  };

  nativeBuildInputs = [
    xtoolBuildHook
    swiftpm
  ];
})
```
:::

## Variables controlling `xtoolBuildHook` {#xtool-build-hook-variables}

### `xtoolBuildFlags` {#xtool-build-hook-flags}

Extra arguments to {command}`xtool dev build`, such as `--triple arm64-apple-ios-simulator` or `--ipa`.

### `xtoolBuildConfig` {#xtool-build-hook-config}

The build configuration, `release` by default.

### `dontUseXtoolBuild` {#xtool-build-hook-dont-build}

Don't use the hook's build phase.

### `dontUseXtoolInstall` {#xtool-build-hook-dont-install}

Don't use the hook's install phase.
