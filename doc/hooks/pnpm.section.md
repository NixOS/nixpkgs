# pnpmBuildHook {#pnpm-build-hook}

[pnpm](https://pnpm.io/) is a an NPM-compatible package manager focused on increasing managment speeds, and reducing disk space.

The `pnpmBuildHook` in Nixpkgs overrides the default build phase for building packages that use pnpm.

## Example code snippet {#pnpm-build-hook-code-snippet}

```
{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpmBuildHook,
  makeBinaryWrapper,
  pnpm_10,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "coolPackages";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "JaneCool";
    repo = "coolpackage";
    tag = finalAttrs.version;
    hash = "...";
  };

  strictDeps = true;

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherversion = 3;
    hash = "...";
  }

  nativeBuildInputs = [
    pnpmConfigHook
    pnpmBuildHook
    makeBinaryWrapper
  ];

  pnpmBuildScript = "build";
  pnpmBuildFlags = [
    "--filter=test"
  ];

  installPhase = ''
    runHook preInstall

    mkdir "$out"
    cp -r dist/* "$out"

    runHook postInstall
  '';

  meta = {
    description = "very cool package that does cool things";
    mainProgram = "cool";
  };
})
```

## Variables controlling pnpmBuildHook {#pnpm-build-hook-variables}

### pnpm Exclusive Variables {#pnpm-build-hook-exclusive-variables}

#### `pnpmBuildScript` {#pnpm-build-hook-script}

Controls the script ran to build the package. By default it is `build`, but it is recommended to set the name explicitly.

#### `pnpmFlags` {#pnpm-build-hook-flags}

Controls flags used for all invocations of pnpm across all hooks local to this derivation.

#### `pnpmBuildFlags` {#pnpm-build-hook-build-flags}

Controls the flags pass only to the pnpm build script invocation.

#### `dontPnpmBuild` {#pnpm-build-hook-dont}

Disables using `pnpmBuildHook`.
