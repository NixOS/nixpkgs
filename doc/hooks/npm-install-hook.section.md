# npmHooks.npmInstallHook {#npm-install-hook}

Hook to install node_modules for npm packages.
Does not create wrappers for executable npm projects
Primarily made for a multi-language environment.

## Examples {#npm-install-hook-snippet}

[](#npm-build-hook-example-snippet)

## Variables controlling `npmInstallHook` {#npm-install-hook-variables}

### `npmInstallHook` Exclusive Variables {#npm-install-hook-exclusive-variables}

#### `dontNpmPrune` {#npm-install-hook-dont-prune}

Whether to run {command}`npm prune` on the `node_modules` or not.
Defaults to `true`.

#### `npmInstallFlags` {#npm-install-hook-prune-flags}

Flags to pass to the {command}`npm prune` call for the `node_modules` of the package.
Defaults to `--omit=dev --no-save` which cannot be modified.

#### `dontNpmInstall` {#npm-install-hook-dont}

Controls whether `npmInstallHook` is enabled or not.
Defaults to `true`, so the hook will run.

### Honored Variables {#npm-install-hook-honored-variables}

The following variables are honored by the `npmInstallHook`.

- [`npmWorkspace`](#javascript-buildNpmPackage-npmWorkspace)
- [`npmFlags`](#javascript-buildNpmPackage-npmFlags)
