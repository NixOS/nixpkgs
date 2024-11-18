# Javascript {#language-javascript}

## Introduction {#javascript-introduction}

This contains instructions on how to package javascript applications.

The various tools available will be listed in the [tools-overview](#javascript-tools-overview).
Some general principles for packaging will follow.
Finally some tool specific instructions will be given.

## Getting unstuck / finding code examples {#javascript-finding-examples}

If you find you are lacking inspiration for packaging javascript applications, the links below might prove useful.
Searching online for prior art can be helpful if you are running into solved problems.

### Github {#javascript-finding-examples-github}

- Searching Nix files for `mkYarnPackage`: <https://github.com/search?q=mkYarnPackage+language%3ANix&type=code>
- Searching just `flake.nix` files for `mkYarnPackage`: <https://github.com/search?q=mkYarnPackage+path%3A**%2Fflake.nix&type=code>

### Gitlab {#javascript-finding-examples-gitlab}

- Searching Nix files for `mkYarnPackage`: <https://gitlab.com/search?scope=blobs&search=mkYarnPackage+extension%3Anix>
- Searching just `flake.nix` files for `mkYarnPackage`: <https://gitlab.com/search?scope=blobs&search=mkYarnPackage+filename%3Aflake.nix>

## Tools overview {#javascript-tools-overview}

## General principles {#javascript-general-principles}

The following principles are given in order of importance with potential exceptions.

### Try to use the same node version used upstream {#javascript-upstream-node-version}

It is often not documented which node version is used upstream, but if it is, try to use the same version when packaging.

This can be a problem if upstream is using the latest and greatest and you are trying to use an earlier version of node.
Some cryptic errors regarding V8 may appear.

### Try to respect the package manager originally used by upstream (and use the upstream lock file) {#javascript-upstream-package-manager}

A lock file (package-lock.json, yarn.lock...) is supposed to make reproducible installations of `node_modules` for each tool.

Guidelines of package managers, recommend to commit those lock files to the repos.
If a particular lock file is present, it is a strong indication of which package manager is used upstream.

It's better to try to use a Nix tool that understand the lock file.
Using a different tool might give you hard to understand error because different packages have been installed.
An example of problems that could arise can be found [here](https://github.com/NixOS/nixpkgs/pull/126629).
Upstream use npm, but this is an attempt to package it with `yarn2nix` (that uses yarn.lock).

Using a different tool forces to commit a lock file to the repository.
Those files are fairly large, so when packaging for nixpkgs, this approach does not scale well.

Exceptions to this rule are:

- When you encounter one of the bugs from a Nix tool. In each of the tool specific instructions, known problems will be detailed. If you have a problem with a particular tool, then it's best to try another tool, even if this means you will have to recreate a lock file and commit it to nixpkgs. In general `yarn2nix` has less known problems and so a simple search in nixpkgs will reveal many yarn.lock files committed.
- Some lock files contain particular version of a package that has been pulled off npm for some reason. In that case, you can recreate upstream lock (by removing the original and `npm install`, `yarn`, ...) and commit this to nixpkgs.
- The only tool that supports workspaces (a feature of npm that helps manage sub-directories with different package.json from a single top level package.json) is `yarn2nix`. If upstream has workspaces you should try `yarn2nix`.

### Try to use upstream package.json {#javascript-upstream-package-json}

Exceptions to this rule are:

- Sometimes the upstream repo assumes some dependencies be installed globally. In that case you can add them manually to the upstream package.json (`yarn add xxx` or `npm install xxx`, ...). Dependencies that are installed locally can be executed with `npx` for CLI tools. (e.g. `npx postcss ...`, this is how you can call those dependencies in the phases).
- Sometimes there is a version conflict between some dependency requirements. In that case you can fix a version by removing the `^`.
- Sometimes the script defined in the package.json does not work as is. Some scripts for example use CLI tools that might not be available, or cd in directory with a different package.json (for workspaces notably). In that case, it's perfectly fine to look at what the particular script is doing and break this down in the phases. In the build script you can see `build:*` calling in turns several other build scripts like `build:ui` or `build:server`. If one of those fails, you can try to separate those into,

  ```sh
  yarn build:ui
  yarn build:server
  # OR
  npm run build:ui
  npm run build:server
  ```

  when you need to override a package.json. It's nice to use the one from the upstream source and do some explicit override. Here is an example:

  ```nix
  {
    patchedPackageJSON = final.runCommand "package.json" { } ''
      ${jq}/bin/jq '.version = "0.4.0" |
        .devDependencies."@jsdoc/cli" = "^0.2.5"
        ${sonar-src}/package.json > $out
    '';
  }
  ```

  You will still need to commit the modified version of the lock files, but at least the overrides are explicit for everyone to see.

### Using node_modules directly {#javascript-using-node_modules}

Each tool has an abstraction to just build the node_modules (dependencies) directory.
You can always use the `stdenv.mkDerivation` with the node_modules to build the package (symlink the node_modules directory and then use the package build command).
The node_modules abstraction can be also used to build some web framework frontends.
For an example of this see how [plausible](https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/web-apps/plausible/default.nix) is built. `mkYarnModules` to make the derivation containing node_modules.
Then when building the frontend you can just symlink the node_modules directory.

## Javascript packages inside nixpkgs {#javascript-packages-nixpkgs}

The [pkgs/development/node-packages](https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/node-packages) folder contains a generated collection of [npm packages](https://npmjs.com/) that can be installed with the Nix package manager.

As a rule of thumb, the package set should only provide _end user_ software packages, such as command-line utilities.
Libraries should only be added to the package set if there is a non-npm package that requires it.

When it is desired to use npm libraries in a development project, use the `node2nix` generator directly on the `package.json` configuration file of the project.

The package set provides support for the official stable Node.js versions.
The latest stable LTS release in `nodePackages`, as well as the latest stable current release in `nodePackages_latest`.

If your package uses native addons, you need to examine what kind of native build system it uses. Here are some examples:

- `node-gyp`
- `node-gyp-builder`
- `node-pre-gyp`

After you have identified the correct system, you need to override your package expression while adding in build system as a build input.
For example, `dat` requires `node-gyp-build`, so we override its expression in [pkgs/development/node-packages/overrides.nix](https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/node-packages/overrides.nix):

```nix
  {
    dat = prev.dat.override (oldAttrs: {
      buildInputs = [ final.node-gyp-build pkgs.libtool pkgs.autoconf pkgs.automake ];
      meta = oldAttrs.meta // { broken = since "12"; };
    });
  }
```

### Adding and Updating Javascript packages in nixpkgs {#javascript-adding-or-updating-packages}

To add a package from npm to nixpkgs:

1. Modify [pkgs/development/node-packages/node-packages.json](https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/node-packages/node-packages.json) to add, update or remove package entries to have it included in `nodePackages` and `nodePackages_latest`.
2. Run the script:

   ```sh
   ./pkgs/development/node-packages/generate.sh
   ```

3. Build your new package to test your changes:

   ```sh
   nix-build -A nodePackages.<new-or-updated-package>
   ```

    To build against the latest stable Current Node.js version (e.g. 18.x):

    ```sh
    nix-build -A nodePackages_latest.<new-or-updated-package>
    ```

    If the package doesn't build, you may need to add an override as explained above.
4. If the package's name doesn't match any of the executables it provides, add an entry in [pkgs/development/node-packages/main-programs.nix](https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/node-packages/main-programs.nix). This will be the case for all scoped packages, e.g., `@angular/cli`.
5. Add and commit all modified and generated files.

For more information about the generation process, consult the [README.md](https://github.com/svanderburg/node2nix) file of the `node2nix` tool.

To update npm packages in nixpkgs, run the same `generate.sh` script:

```sh
./pkgs/development/node-packages/generate.sh
```

#### Git protocol error {#javascript-git-error}

Some packages may have Git dependencies from GitHub specified with `git://`.
GitHub has [disabled unencrypted Git connections](https://github.blog/2021-09-01-improving-git-protocol-security-github/#no-more-unauthenticated-git), so you may see the following error when running the generate script:

```
The unauthenticated git protocol on port 9418 is no longer supported
```

Use the following Git configuration to resolve the issue:

```sh
git config --global url."https://github.com/".insteadOf git://github.com/
```

## Tool specific instructions {#javascript-tool-specific}

### buildNpmPackage {#javascript-buildNpmPackage}

`buildNpmPackage` allows you to package npm-based projects in Nixpkgs without the use of an auto-generated dependencies file (as used in [node2nix](#javascript-node2nix)).
It works by utilizing npm's cache functionality -- creating a reproducible cache that contains the dependencies of a project, and pointing npm to it.

Here's an example:

```nix
{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "flood";
  version = "4.7.0";

  src = fetchFromGitHub {
    owner = "jesec";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-BR+ZGkBBfd0dSQqAvujsbgsEPFYw/ThrylxUbOksYxM=";
  };

  npmDepsHash = "sha256-tuEfyePwlOy2/mOPdXbqJskO6IowvAP4DWg8xSZwbJw=";

  # The prepack script runs the build script, which we'd rather do in the build phase.
  npmPackFlags = [ "--ignore-scripts" ];

  NODE_OPTIONS = "--openssl-legacy-provider";

  meta = {
    description = "Modern web UI for various torrent clients with a Node.js backend and React frontend";
    homepage = "https://flood.js.org";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ winter ];
  };
}
```

In the default `installPhase` set by `buildNpmPackage`, it uses `npm pack --json --dry-run` to decide what files to install in `$out/lib/node_modules/$name/`, where `$name` is the `name` string defined in the package's `package.json`.
Additionally, the `bin` and `man` keys in the source's `package.json` are used to decide what binaries and manpages are supposed to be installed.
If these are not defined, `npm pack` may miss some files, and no binaries will be produced.

#### Arguments {#javascript-buildNpmPackage-arguments}

* `npmDepsHash`: The output hash of the dependencies for this project. Can be calculated in advance with [`prefetch-npm-deps`](#javascript-buildNpmPackage-prefetch-npm-deps).
* `makeCacheWritable`: Whether to make the cache writable prior to installing dependencies. Don't set this unless npm tries to write to the cache directory, as it can slow down the build.
* `npmBuildScript`: The script to run to build the project. Defaults to `"build"`.
* `npmWorkspace`: The workspace directory within the project to build and install.
* `dontNpmBuild`: Option to disable running the build script. Set to `true` if the package does not have a build script. Defaults to `false`. Alternatively, setting `buildPhase` explicitly also disables this.
* `dontNpmInstall`: Option to disable running `npm install`. Defaults to `false`. Alternatively, setting `installPhase` explicitly also disables this.
* `npmFlags`: Flags to pass to all npm commands.
* `npmInstallFlags`: Flags to pass to `npm ci`.
* `npmBuildFlags`: Flags to pass to `npm run ${npmBuildScript}`.
* `npmPackFlags`: Flags to pass to `npm pack`.
* `npmPruneFlags`: Flags to pass to `npm prune`. Defaults to the value of `npmInstallFlags`.
* `makeWrapperArgs`: Flags to pass to `makeWrapper`, added to executable calling the generated `.js` with `node` as an interpreter. These scripts are defined in `package.json`.
* `nodejs`: The `nodejs` package to build against, using the corresponding `npm` shipped with that version of `node`. Defaults to `pkgs.nodejs`.
* `npmDeps`: The dependencies used to build the npm package. Especially useful to not have to recompute workspace dependencies.

#### prefetch-npm-deps {#javascript-buildNpmPackage-prefetch-npm-deps}

`prefetch-npm-deps` is a Nixpkgs package that calculates the hash of the dependencies of an npm project ahead of time.

```console
$ ls
package.json package-lock.json index.js
$ prefetch-npm-deps package-lock.json
...
sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
```

#### fetchNpmDeps {#javascript-buildNpmPackage-fetchNpmDeps}

`fetchNpmDeps` is a Nix function that requires the following mandatory arguments:

- `src`: A directory / tarball with `package-lock.json` file
- `hash`: The output hash of the node dependencies defined in `package-lock.json`.

It returns a derivation with all `package-lock.json` dependencies downloaded into `$out/`, usable as an npm cache.

#### importNpmLock {#javascript-buildNpmPackage-importNpmLock}

This function replaces the npm dependency references in `package.json` and `package-lock.json` with paths to the Nix store.
How each dependency is fetched can be customized with the `fetcherOpts` argument.

This is a simpler and more convenient alternative to [`fetchNpmDeps`](#javascript-buildNpmPackage-fetchNpmDeps) for managing npm dependencies in Nixpkgs.
There is no need to specify a `hash`, since it relies entirely on the integrity hashes already present in the `package-lock.json` file.

##### Inputs {#javascript-buildNpmPackage-inputs}

- `npmRoot`: Path to package directory containing the source tree.
  If this is omitted, the `package` and `packageLock` arguments must be specified instead.
- `package`: Parsed contents of `package.json`
- `packageLock`: Parsed contents of `package-lock.json`
- `pname`: Package name
- `version`: Package version
- `fetcherOpts`: An attribute set of arguments forwarded to the underlying fetcher.

It returns a derivation with a patched `package.json` & `package-lock.json` with all dependencies resolved to Nix store paths.

:::{.note}
`npmHooks.npmConfigHook` cannot be used with `importNpmLock`.
Use `importNpmLock.npmConfigHook` instead.
:::

:::{.example}

##### `pkgs.importNpmLock` usage example {#javascript-buildNpmPackage-example}
```nix
{ buildNpmPackage, importNpmLock }:

buildNpmPackage {
  pname = "hello";
  version = "0.1.0";
  src = ./.;

  npmDeps = importNpmLock {
    npmRoot = ./.;
  };

  npmConfigHook = importNpmLock.npmConfigHook;
}
```
:::

:::{.example}
##### `pkgs.importNpmLock` usage example with `fetcherOpts` {#javascript-buildNpmPackage-example-fetcherOpts}

`importNpmLock` uses the following fetchers:

- `pkgs.fetchurl` for `http(s)` dependencies
- `builtins.fetchGit` for `git` dependencies

It is possible to provide additional arguments to individual fetchers as needed:

```nix
{ buildNpmPackage, importNpmLock }:

buildNpmPackage {
  pname = "hello";
  version = "0.1.0";
  src = ./.;

  npmDeps = importNpmLock {
    npmRoot = ./.;
    fetcherOpts = {
      # Pass 'curlOptsList' to 'pkgs.fetchurl' while fetching 'axios'
      { "node_modules/axios" = { curlOptsList = [ "--verbose" ]; }; }
    };
  };

  npmConfigHook = importNpmLock.npmConfigHook;
}
```
:::

#### importNpmLock.buildNodeModules {#javascript-buildNpmPackage-importNpmLock.buildNodeModules}

`importNpmLock.buildNodeModules` returns a derivation with a pre-built `node_modules` directory, as imported by `importNpmLock`.

This is to be used together with `importNpmLock.hooks.linkNodeModulesHook` to facilitate `nix-shell`/`nix develop` based development workflows.

It accepts an argument with the following attributes:

`npmRoot` (Path; optional)
: Path to package directory containing the source tree. If not specified, the `package` and `packageLock` arguments must both be specified.

`package` (Attrset; optional)
: Parsed contents of `package.json`, as returned by `lib.importJSON ./my-package.json`. If not specified, the `package.json` in `npmRoot` is used.

`packageLock` (Attrset; optional)
: Parsed contents of `package-lock.json`, as returned `lib.importJSON ./my-package-lock.json`. If not specified, the `package-lock.json` in `npmRoot` is used.

`derivationArgs` (`mkDerivation` attrset; optional)
: Arguments passed to `stdenv.mkDerivation`

For example:

```nix
pkgs.mkShell {
  packages = [
    importNpmLock.hooks.linkNodeModulesHook
    nodejs
  ];

  npmDeps = importNpmLock.buildNodeModules {
    npmRoot = ./.;
    inherit nodejs;
  };
}
```
will create a development shell where a `node_modules` directory is created & packages symlinked to the Nix store when activated.

### corepack {#javascript-corepack}

This package puts the corepack wrappers for pnpm and yarn in your PATH, and they will honor the `packageManager` setting in the `package.json`.

### node2nix {#javascript-node2nix}

#### Preparation {#javascript-node2nix-preparation}

You will need to generate a Nix expression for the dependencies. Don't forget the `-l package-lock.json` if there is a lock file. Most probably you will need the `--development` to include the `devDependencies`

So the command will most likely be:
```sh
node2nix --development -l package-lock.json
```

See `node2nix` [docs](https://github.com/svanderburg/node2nix) for more info.

#### Pitfalls {#javascript-node2nix-pitfalls}

- If upstream package.json does not have a "version" attribute, `node2nix` will crash. You will need to add it like shown in [the package.json section](#javascript-upstream-package-json).
- `node2nix` has some [bugs](https://github.com/svanderburg/node2nix/issues/238) related to working with lock files from npm distributed with `nodejs_16`.
- `node2nix` does not like missing packages from npm. If you see something like `Cannot resolve version: vue-loader-v16@undefined` then you might want to try another tool. The package might have been pulled off of npm.

### pnpm {#javascript-pnpm}

Pnpm is available as the top-level package `pnpm`. Additionally, there are variants pinned to certain major versions, like `pnpm_8` and `pnpm_9`, which support different sets of lock file versions.

When packaging an application that includes a `pnpm-lock.yaml`, you need to fetch the pnpm store for that project using a fixed-output-derivation. The functions `pnpm_8.fetchDeps` and `pnpm_9.fetchDeps` can create this pnpm store derivation. In conjunction, the setup hooks `pnpm_8.configHook` and `pnpm_9.configHook` will prepare the build environment to install the prefetched dependencies store. Here is an example for a package that contains a `package.json` and a `pnpm-lock.yaml` files using the above `pnpm_` attributes:

```nix
{
  stdenv,
  nodejs,
  # This is pinned as { pnpm = pnpm_9; }
  pnpm
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "foo";
  version = "0-unstable-1980-01-01";

  src = ...;

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "...";
  };
})
```

NOTE: It is highly recommended to use a pinned version of pnpm (i.e. `pnpm_8` or `pnpm_9`), to increase future reproducibility. It might also be required to use an older version, if the package needs support for a certain lock file version.

In case you are patching `package.json` or `pnpm-lock.yaml`, make sure to pass `finalAttrs.patches` to the function as well (i.e. `inherit (finalAttrs) patches`.

`pnpm.configHook` supports adding additional `pnpm install` flags via `pnpmInstallFlags` which can be set to a Nix string array:

```nix
{
  pnpm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "foo";
  version = "0-unstable-1980-01-01";

  src = ...;

  pnpmInstallFlags = [ "--shamefully-hoist" ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pnpmInstallFlags;
  };
})
```

#### Dealing with `sourceRoot` {#javascript-pnpm-sourceRoot}

If the pnpm project is in a subdirectory, you can just define `sourceRoot` or `setSourceRoot` for `fetchDeps`.
If `sourceRoot` is different between the parent derivation and `fetchDeps`, you will have to set `pnpmRoot` to effectively be the same location as it is in `fetchDeps`.

Assuming the following directory structure, we can define `sourceRoot` and `pnpmRoot` as follows:

```
.
├── frontend
│   ├── ...
│   ├── package.json
│   └── pnpm-lock.yaml
└── ...
```

```nix
  ...
  pnpmDeps = pnpm.fetchDeps {
    ...
    sourceRoot = "${finalAttrs.src.name}/frontend";
  };

  # by default the working directory is the extracted source
  pnpmRoot = "frontend";
```

#### PNPM Workspaces {#javascript-pnpm-workspaces}

If you need to use a PNPM workspace for your project, then set `pnpmWorkspaces = [ "<workspace project name 1>" "<workspace project name 2>" ]`, etc, in your `pnpm.fetchDeps` call,
which will make PNPM only install dependencies for those workspace packages.

For example:

```nix
...
pnpmWorkspaces = [ "@astrojs/language-server" ];
pnpmDeps = pnpm.fetchDeps {
  inherit (finalAttrs) pnpmWorkspaces;
  ...
}
```

The above would make `pnpm.fetchDeps` call only install dependencies for the `@astrojs/language-server` workspace package.
Note that you do not need to set `sourceRoot` to make this work.

Usually in such cases, you'd want to use `pnpm --filter=<pnpm workspace name> build` to build your project, as `npmHooks.npmBuildHook` probably won't work. A `buildPhase` based on the following example will probably fit most workspace projects:

```nix
buildPhase = ''
  runHook preBuild

  pnpm --filter=@astrojs/language-server build

  runHook postBuild
'';
```

#### Additional PNPM Commands and settings {#javascript-pnpm-extraCommands}

If you require setting an additional PNPM configuration setting (such as `dedupe-peer-dependents` or similar),
set `prePnpmInstall` to the right commands to run. For example:

```nix
prePnpmInstall = ''
  pnpm config set dedupe-peer-dependants false
'';
pnpmDeps = pnpm.fetchDeps {
  inherit (finalAttrs) prePnpmInstall;
  ...
};
```

In this example, `prePnpmInstall` will be run by both `pnpm.configHook` and by the `pnpm.fetchDeps` builder.


### Yarn {#javascript-yarn}

Yarn based projects use a `yarn.lock` file instead of a `package-lock.json` to pin dependencies. Nixpkgs provides the Nix function `fetchYarnDeps` which fetches an offline cache suitable for running `yarn install` before building the project. In addition, Nixpkgs provides the hooks:

- `yarnConfigHook`: Fetches the dependencies from the offline cache and installs them into `node_modules`.
- `yarnBuildHook`: Runs `yarn build` or a specified `yarn` command that builds the project.
- `yarnInstallHook`: Runs `yarn install --production` to prune dependencies and installs the project into `$out`.

An example usage of the above attributes is:

```nix
{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodejs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "...";
  version = "...";

  src = fetchFromGitHub {
    owner = "...";
    repo = "...";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    # Needed for executing package.json scripts
    nodejs
  ];

  meta = {
    # ...
  };
})
```

#### `yarnConfigHook` arguments {#javascript-yarnconfighook}

By default, `yarnConfigHook` relies upon the attribute `${yarnOfflineCache}` (or `${offlineCache}` if the former is not set) to find the location of the offline cache produced by `fetchYarnDeps`. To disable this phase, you can set `dontYarnInstallDeps = true` or override the `configurePhase`.

#### `yarnBuildHook` arguments {#javascript-yarnbuildhook}

This script by default runs `yarn --offline build`, and it relies upon the project's dependencies installed at `node_modules`. Below is a list of additional `mkDerivation` arguments read by this hook:

- `yarnBuildScript`: Sets a different `yarn --offline` subcommand (defaults to `build`).
- `yarnBuildFlags`: Single string list of additional flags to pass the above command, or a Nix list of such additional flags.

#### `yarnInstallHook` arguments {#javascript-yarninstallhook}

To install the package `yarnInstallHook` uses both `npm` and `yarn` to cleanup project files and dependencies. To disable this phase, you can set `dontYarnInstall = true` or override the `installPhase`. Below is a list of additional `mkDerivation` arguments read by this hook:

- `yarnKeepDevDeps`: Disables the removal of devDependencies from `node_modules` before installation.

### yarn2nix {#javascript-yarn2nix}

WARNING: The `yarn2nix` functions have been deprecated in favor of the new `yarnConfigHook`, `yarnBuildHook` and `yarnInstallHook`. Documentation for them still appears here for the sake of the packages that still use them. See also a tracking issue [#324246](https://github.com/NixOS/nixpkgs/issues/324246).

#### Preparation {#javascript-yarn2nix-preparation}

You will need at least a `yarn.lock` file. If upstream does not have one you need to generate it and reference it in your package definition.

If the downloaded files contain the `package.json` and `yarn.lock` files they can be used like this:

```nix
{
  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "....";
  };
}
```

#### mkYarnPackage {#javascript-yarn2nix-mkYarnPackage}

`mkYarnPackage` will by default try to generate a binary. For package only generating static assets (Svelte, Vue, React, WebPack, ...), you will need to explicitly override the build step with your instructions.

It's important to use the `--offline` flag. For example if you script is `"build": "something"` in `package.json` use:

```nix
{
  buildPhase = ''
    export HOME=$(mktemp -d)
    yarn --offline build
  '';
}
```

The `distPhase` is packing the package's dependencies in a tarball using `yarn pack`. You can disable it using:

```nix
{
  doDist = false;
}
```

The configure phase can sometimes fail because it makes many assumptions which may not always apply. One common override is:

```nix
{
  configurePhase = ''
    ln -s $node_modules node_modules
  '';
}
```

or if you need a writeable node_modules directory:

```nix
{
  configurePhase = ''
    cp -r $node_modules node_modules
    chmod +w node_modules
  '';
}
```

#### mkYarnModules {#javascript-yarn2nix-mkYarnModules}

This will generate a derivation including the `node_modules` directory.
If you have to build a derivation for an integrated web framework (rails, phoenix..), this is probably the easiest way.

#### Overriding dependency behavior {#javascript-mkYarnPackage-overriding-dependencies}

In the `mkYarnPackage` record the property `pkgConfig` can be used to override packages when you encounter problems building.

For instance, say your package is throwing errors when trying to invoke node-sass:

```
ENOENT: no such file or directory, scandir '/build/source/node_modules/node-sass/vendor'
```

To fix this we will specify different versions of build inputs to use, as well as some post install steps to get the software built the way we want:

```nix
mkYarnPackage rec {
  pkgConfig = {
    node-sass = {
      buildInputs = with final;[ python libsass pkg-config ];
      postInstall = ''
        LIBSASS_EXT=auto yarn --offline run build
        rm build/config.gypi
      '';
    };
  };
}
```

#### Pitfalls {#javascript-yarn2nix-pitfalls}

- If version is missing from upstream package.json, yarn will silently install nothing. In that case, you will need to override package.json as shown in the [package.json section](#javascript-upstream-package-json)
- Having trouble with `node-gyp`? Try adding these lines to the `yarnPreBuild` steps:

  ```nix
  {
    yarnPreBuild = ''
      mkdir -p $HOME/.node-gyp/${nodejs.version}
      echo 9 > $HOME/.node-gyp/${nodejs.version}/installVersion
      ln -sfv ${nodejs}/include $HOME/.node-gyp/${nodejs.version}
      export npm_config_nodedir=${nodejs}
    '';
  }
  ```

  - The `echo 9` steps comes from this answer: <https://stackoverflow.com/a/49139496>
  - Exporting the headers in `npm_config_nodedir` comes from this issue: <https://github.com/nodejs/node-gyp/issues/1191#issuecomment-301243919>
- `offlineCache` (described [above](#javascript-yarn2nix-preparation)) must be specified to avoid [Import From Derivation](#ssec-import-from-derivation) (IFD) when used inside Nixpkgs.

## Outside Nixpkgs {#javascript-outside-nixpkgs}

There are some other tools available, which are written in the Nix language.
These that can't be used inside Nixpkgs because they require [Import From Derivation](#ssec-import-from-derivation), which is not allowed in Nixpkgs.

If you are packaging something outside Nixpkgs, consider the following:

### npmlock2nix {#javascript-npmlock2nix}

[npmlock2nix](https://github.com/nix-community/npmlock2nix) aims at building `node_modules` without code generation. It hasn't reached v1 yet, the API might be subject to change.

#### Pitfalls {#javascript-npmlock2nix-pitfalls}

There are some [problems with npm v7](https://github.com/tweag/npmlock2nix/issues/45).

### nix-npm-buildpackage {#javascript-nix-npm-buildpackage}

[nix-npm-buildpackage](https://github.com/serokell/nix-npm-buildpackage) aims at building `node_modules` without code generation. It hasn't reached v1 yet, the API might change. It supports both `package-lock.json` and yarn.lock.

#### Pitfalls {#javascript-nix-npm-buildpackage-pitfalls}

There are some [problems with npm v7](https://github.com/serokell/nix-npm-buildpackage/issues/33).
