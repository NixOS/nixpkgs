# npmHooks.npmConfigHook {#npm-config-hook}

Hook for configuring packages that use npm.
Primarily made for a multi-language environment.

## Examples {#npm-config-hook-snippet}

[](#npm-build-hook-example-snippet)

## Variables controlling `npmConfigHook` {#npm-config-hook-variables}

### `npmConfigHook` Exclusive Variables {#npm-config-hook-exclusive-variables}

#### `npmDeps` {#npm-config-hook-deps}

Derivation that contains the NPM package dependencies.
Usually built with `fetchNpmDeps`.
This attribute is required or the hook will abort the build.

#### `makeCacheWritable` {#npm-config-hook-writable-cache}

Whether to make the dependency cache writable prior to installing the dependencies.
Don't set this unless npm tries to write to the cache directory.

#### `npmInstallFlags` {#npm-config-hook-install-flags}

Flags to pass to the {command}`npm ci` call for installing the dependencies to the build environment.
Defaults to `--ignore-scripts`, which cannot be removed.
This does not control anything with the `npmInstallHook`.

#### `npmRebuildFlags` {#npm-config-hook-rebuild-flags}

Flags to pass to the {command}`npm rebuild` command after the dependencies are installed to the environment.

### Honored Variables {#npm-config-hook-honored-variables}

The following variables are honored by the `npmConfigHook`.

- [`npmWorkspace`](#javascript-buildNpmPackage-npmWorkspace)
- [`npmFlags`](#javascript-buildNpmPackage-npmFlags)
- `npmRoot`
