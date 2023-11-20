# Javascript {#language-javascript}

## Introduction {#javascript-introduction}

This contains instructions on how to package javascript applications.

The various tools available will be listed in the [tools-overview](#javascript-tools-overview). Some general principles for packaging will follow. Finally some tool specific instructions will be given.

## Getting unstuck / finding code examples {#javascript-finding-examples}

If you find you are lacking inspiration for packing javascript applications, the links below might prove useful. Searching online for prior art can be helpful if you are running into solved problems.

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

This can be a problem if upstream is using the latest and greatest and you are trying to use an earlier version of node. Some cryptic errors regarding V8 may appear.

### Try to respect the package manager originally used by upstream (and use the upstream lock file) {#javascript-upstream-package-manager}

A lock file (package-lock.json, yarn.lock...) is supposed to make reproducible installations of node_modules for each tool.

Guidelines of package managers, recommend to commit those lock files to the repos. If a particular lock file is present, it is a strong indication of which package manager is used upstream.

It's better to try to use a Nix tool that understand the lock file. Using a different tool might give you hard to understand error because different packages have been installed. An example of problems that could arise can be found [here](https://github.com/NixOS/nixpkgs/pull/126629). Upstream use NPM, but this is an attempt to package it with `yarn2nix` (that uses yarn.lock).

Using a different tool forces to commit a lock file to the repository. Those files are fairly large, so when packaging for nixpkgs, this approach does not scale well.

Exceptions to this rule are:

- When you encounter one of the bugs from a Nix tool. In each of the tool specific instructions, known problems will be detailed. If you have a problem with a particular tool, then it's best to try another tool, even if this means you will have to recreate a lock file and commit it to nixpkgs. In general `yarn2nix` has less known problems and so a simple search in nixpkgs will reveal many yarn.lock files committed.
- Some lock files contain particular version of a package that has been pulled off NPM for some reason. In that case, you can recreate upstream lock (by removing the original and `npm install`, `yarn`, ...) and commit this to nixpkgs.
- The only tool that supports workspaces (a feature of NPM that helps manage sub-directories with different package.json from a single top level package.json) is `yarn2nix`. If upstream has workspaces you should try `yarn2nix`.

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
  patchedPackageJSON = final.runCommand "package.json" { } ''
    ${jq}/bin/jq '.version = "0.4.0" |
      .devDependencies."@jsdoc/cli" = "^0.2.5"
      ${sonar-src}/package.json > $out
  '';
  ```

  You will still need to commit the modified version of the lock files, but at least the overrides are explicit for everyone to see.

### Using node_modules directly {#javascript-using-node_modules}

Each tool has an abstraction to just build the node_modules (dependencies) directory. You can always use the `stdenv.mkDerivation` with the node_modules to build the package (symlink the node_modules directory and then use the package build command). The node_modules abstraction can be also used to build some web framework frontends. For an example of this see how [plausible](https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/web-apps/plausible/default.nix) is built. `mkYarnModules` to make the derivation containing node_modules. Then when building the frontend you can just symlink the node_modules directory.

## Javascript packages inside nixpkgs {#javascript-packages-nixpkgs}

The [pkgs/development/node-packages](https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/node-packages) folder contains a generated collection of [NPM packages](https://npmjs.com/) that can be installed with the Nix package manager.

As a rule of thumb, the package set should only provide _end user_ software packages, such as command-line utilities. Libraries should only be added to the package set if there is a non-NPM package that requires it.

When it is desired to use NPM libraries in a development project, use the `node2nix` generator directly on the `package.json` configuration file of the project.

The package set provides support for the official stable Node.js versions. The latest stable LTS release in `nodePackages`, as well as the latest stable current release in `nodePackages_latest`.

If your package uses native addons, you need to examine what kind of native build system it uses. Here are some examples:

- `node-gyp`
- `node-gyp-builder`
- `node-pre-gyp`

After you have identified the correct system, you need to override your package expression while adding in build system as a build input. For example, `dat` requires `node-gyp-build`, so we override its expression in [pkgs/development/node-packages/overrides.nix](https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/node-packages/overrides.nix):

```nix
    dat = prev.dat.override (oldAttrs: {
      buildInputs = [ final.node-gyp-build pkgs.libtool pkgs.autoconf pkgs.automake ];
      meta = oldAttrs.meta // { broken = since "12"; };
    });
```

### Adding and Updating Javascript packages in nixpkgs {#javascript-adding-or-updating-packages}

To add a package from NPM to nixpkgs:

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

To update NPM packages in nixpkgs, run the same `generate.sh` script:

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

`buildNpmPackage` allows you to package npm-based projects in Nixpkgs without the use of an auto-generated dependencies file (as used in [node2nix](#javascript-node2nix)). It works by utilizing npm's cache functionality -- creating a reproducible cache that contains the dependencies of a project, and pointing npm to it.

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

  meta = with lib; {
    description = "A modern web UI for various torrent clients with a Node.js backend and React frontend";
    homepage = "https://flood.js.org";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ winter ];
  };
}
```

In the default `installPhase` set by `buildNpmPackage`, it uses `npm pack --json --dry-run` to decide what files to install in `$out/lib/node_modules/$name/`, where `$name` is the `name` string defined in the package's `package.json`. Additionally, the `bin` and `man` keys in the source's `package.json` are used to decide what binaries and manpages are supposed to be installed. If these are not defined, `npm pack` may miss some files, and no binaries will be produced.

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
* `npmDeps`: The dependencies used to build the npm package. Especially useful to not have to recompute workspace depedencies.

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
- `node2nix` has some [bugs](https://github.com/svanderburg/node2nix/issues/238) related to working with lock files from NPM distributed with `nodejs_16`.
- `node2nix` does not like missing packages from NPM. If you see something like `Cannot resolve version: vue-loader-v16@undefined` then you might want to try another tool. The package might have been pulled off of NPM.

### yarn2nix {#javascript-yarn2nix}

#### Preparation {#javascript-yarn2nix-preparation}

You will need at least a `yarn.lock` file. If upstream does not have one you need to generate it and reference it in your package definition.

If the downloaded files contain the `package.json` and `yarn.lock` files they can be used like this:

```nix
offlineCache = fetchYarnDeps {
  yarnLock = src + "/yarn.lock";
  hash = "....";
};
```

#### mkYarnPackage {#javascript-yarn2nix-mkYarnPackage}

`mkYarnPackage` will by default try to generate a binary. For package only generating static assets (Svelte, Vue, React, WebPack, ...), you will need to explicitly override the build step with your instructions.

It's important to use the `--offline` flag. For example if you script is `"build": "something"` in `package.json` use:

```nix
buildPhase = ''
  export HOME=$(mktemp -d)
  yarn --offline build
'';
```

The dist phase is also trying to build a binary, the only way to override it is with:

```nix
distPhase = "true";
```

The configure phase can sometimes fail because it makes many assumptions which may not always apply. One common override is:

```nix
configurePhase = ''
  ln -s $node_modules node_modules
'';
```

or if you need a writeable node_modules directory:

```nix
configurePhase = ''
  cp -r $node_modules node_modules
  chmod +w node_modules
'';
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
  yarnPreBuild = ''
    mkdir -p $HOME/.node-gyp/${nodejs.version}
    echo 9 > $HOME/.node-gyp/${nodejs.version}/installVersion
    ln -sfv ${nodejs}/include $HOME/.node-gyp/${nodejs.version}
    export npm_config_nodedir=${nodejs}
  '';
  ```

  - The `echo 9` steps comes from this answer: <https://stackoverflow.com/a/49139496>
  - Exporting the headers in `npm_config_nodedir` comes from this issue: <https://github.com/nodejs/node-gyp/issues/1191#issuecomment-301243919>

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
