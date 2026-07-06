# npmHooks.npmBuildHook {#npm-build-hook}

Hook for building packages that use npm. Can be used in multi-language environments.

## Examples {#npm-build-hook-snippet}

:::{.example #npm-build-hook-example-snippet}

# Using `npmHooks`

```nix
{
  stdenv,
  fetchFromGitHub,
  fetchNpmDeps,
  npmHooks,
  nodejsInstallExecutables,
  nodejsInstallManuals,
  nodejs,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "some-npm-project";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "JohnNpm";
    repo = "SomeProject";
    tag = finalAttrs.version;
    hash = "...";
  };

  strictDeps = true;

  nativeBuildInputs = [
    nodejs
    nodejsInstallExecutables
    nodejsInstallManuals
    npmHooks.npmConfigHook
    npmHooks.npmBuildHook
    npmHooks.npmInstallHook
  ];

  npmBuildScript = "build";

  npmBuildFlags = [
    "--prod"
  ];

  npmFlags = [
    "--ignore-scripts"
  ];

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "...";
  };

  makeWrapperArgs = [
    "--set"
    "NODE_ENV"
    "production"
  ];

  meta = {
    description = "npm project";
  };
})
```
:::

## Variables controlling `npmBuildHook` {#npm-build-hook-variables}

### `npmBuildHook` Exclusive Variables {#npm-build-hook-exclusive-variables}

#### `npmBuildScript` {#npm-build-hook-script}

Controls the script ran to build the npm package within the `package.json` file.
Required to be set, usually to `build`, but can vary between packages.

#### `npmBuildFlags` {#npm-build-hook-flags}

Controls the arguments to the {command}`npm run $npmBuildScript` command.

#### `dontNpmBuild` {#npm-build-hook-dont}

Disables `npmBuildHook` when enabled

### Honored Variables {#npm-build-hook-honored-variables}

The following variables are honored by the `npmBuildHook`.

- [`npmWorkspace`](#javascript-buildNpmPackage-npmWorkspace)
- [`npmFlags`](#javascript-buildNpmPackage-npmFlags)
