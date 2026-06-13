# pnpmBuildHook {#pnpm-build-hook}

[pnpm](https://pnpm.io/) is a an NPM-compatible package manager focused on increasing managment speeds, and reducing disk space.

The `pnpmBuildHook` in Nixpkgs overrides the default build phase for building packages that use pnpm.

:::{.example #ex-pnpm-build-hook}
## pnpmBuildHook example code snippet {#pnpm-build-hook-code-snippet}

```nix
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
let
  pnpm = pnpm_10;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "coolPackages";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "JaneCool";
    repo = "coolpackage";
    tag = finalAttrs.version;
    hash = lib.fakeHash;
  };

  __structuredAttrs = true;
  strictDeps = true;

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherversion = 4;
    hash = lib.fakeHash;
  };

  nativeBuildInputs = [
    pnpmConfigHook
    pnpmBuildHook
    makeBinaryWrapper
  ];

  pnpmBuildScript = "build";
  pnpmBuildFlags = [
    "--mode"
    "production"
  ];
  pnpmWorkspaces = [
    "test"
  ];

  installPhase = ''
    runHook preInstall

    mkdir "$out"
    cp -r dist/. "$out"

    runHook postInstall
  '';

  meta = {
    description = "very cool package that does cool things";
    mainProgram = "cool";
  };
})
```
:::

## Variables controlling pnpmBuildHook {#pnpm-build-hook-variables}

### pnpm Exclusive Variables {#pnpm-build-hook-exclusive-variables}

#### `pnpmBuildScript` {#pnpm-build-hook-script}

Controls the script ran to build the package, by default the script is `build`.

#### `pnpmFlags` {#pnpm-build-hook-flags}

Controls flags used for all invocations of pnpm across all hooks local to this derivation.

#### `pnpmBuildFlags` {#pnpm-build-hook-build-flags}

Controls the flags pass only to the pnpm build script invocation.

#### `dontPnpmBuild` {#pnpm-build-hook-dont}

Disables automatically running `pnpmBuildHook`. The build can still be run manually if needed, for example:

```nix
{
  lib,
  rustPlatform,
  pnpmBuildHook,
  pnpmConfigHook,
  fetchPnpmDeps,
  emptyDirectory,
  pnpm_10,
}:
let
  pnpm = pnpm_10;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "super-fast-application";
  version = "1.0";

  src = emptyDirectory;

  cargoHash = lib.fakeHash;

  nativeBuildInputs = [
    pnpmBuildHook
    pnpmConfigHook
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherversion = 4;
    hash = lib.fakeHash;
  };

  dontPnpmBuild = true;
  postBuild = ''
    pnpmBuildHook
  '';
})
```

### Honored Variables {#pnpm-build-hook-honored-variables}

The following variables are honored by `pnpmBuildHook`.

* [`pnpmRoot`](#javascript-pnpm-sourceRoot)
* [`pnpmWorkspaces`](#javascript-pnpm-workspaces)
