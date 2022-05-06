# Javascript {#language-javascript}

## Introduction {#javascript-introduction}

This contains instructions on how to package javascript applications.

The various tools available will be listed in the [tools-overview](#javascript-tools-overview). Some general principles for packaging will follow. Finally some tool specific instructions will be given.

## Getting unstuck / finding code examples

If you find you are lacking inspiration for packing javascript applications, the links below might prove useful.
Searching online for prior art can be helpful if you are running into solved problems.

### Github

- Searching Nix files for `mkYarnPackage`: <https://github.com/search?q=mkYarnPackage+language%3ANix&type=code>

- Searching just `flake.nix` files for `mkYarnPackage`: <https://github.com/search?q=mkYarnPackage+filename%3Aflake.nix&type=code>

### Gitlab

- Searching Nix files for `mkYarnPackage`: <https://gitlab.com/search?scope=blobs&search=mkYarnPackage+extension%3Anix>

- Searching just `flake.nix` files for `mkYarnPackage`: <https://gitlab.com/search?scope=blobs&search=mkYarnPackage+filename%3Aflake.nix>

## Tools overview {#javascript-tools-overview}

## General principles {#javascript-general-principles}

The following principles are given in order of importance with potential exceptions.

### Try to use the same node version used upstream {#javascript-upstream-node-version}

It is often not documented which node version is used upstream, but if it is, try to use the same version when packaging.

This can be a problem if upstream is using the latest and greatest and you are trying to use an earlier version of node. Some cryptic errors regarding V8 may appear.

An exception to this:

### Try to respect the package manager originally used by upstream (and use the upstream lock file) {#javascript-upstream-package-manager}

A lock file (package-lock.json, yarn.lock...) is supposed to make reproducible installations of node_modules for each tool.

Guidelines of package managers, recommend to commit those lock files to the repos. If a particular lock file is present, it is a strong indication of which package manager is used upstream.

It's better to try to use a nix tool that understand the lock file. Using a different tool might give you hard to understand error because different packages have been installed. An example of problems that could arise can be found [here](https://github.com/NixOS/nixpkgs/pull/126629). Upstream uses npm, but this is an attempt to package it with yarn2nix (that uses yarn.lock)

Using a different tool forces to commit a lock file to the repository. Those files are fairly large, so when packaging for nixpkgs, this approach does not scale well.

Exceptions to this rule are:

- when you encounter one of the bugs from a nix tool. In each of the tool specific instructions, known problems will be detailed. If you have a problem with a particular tool, then it's best to try another tool, even if this means you will have to recreate a lock file and commit it to nixpkgs. In general yarn2nix has less known problems and so a simple search in nixpkgs will reveal many yarn.lock files committed
- Some lock files contain particular version of a package that has been pulled off npm for some reason. In that case, you can recreate upstream lock (by removing the original and `npm install`, `yarn`, ...) and commit this to nixpkgs.
- The only tool that supports workspaces (a feature of npm that helps manage sub-directories with different package.json from a single top level package.json) is yarn2nix. If upstream has workspaces you should try yarn2nix.

### Try to use upstream package.json {#javascript-upstream-package-json}

Exceptions to this rule are

- Sometimes the upstream repo assumes some dependencies be installed globally. In that case you can add them manually to the upstream package.json (`yarn add xxx` or `npm install xxx`, ...). Dependencies that are installed locally can be executed with `npx` for cli tools. (e.g. `npx postcss ...`, this is how you can call those dependencies in the phases).
- Sometimes there is a version conflict between some dependency requirements. In that case you can fix a version (by removing the `^`).
- Sometimes the script defined in the package.json does not work as is. Some scripts for example use cli tools that might not be available, or cd in directory with a different package.json (for workspaces notably). In that case, it's perfectly fine to look at what the particular script is doing and break this down in the phases. In the build script you can see `build:*` calling in turns several other build scripts like `build:ui` or `build:server`. If one of those fails, you can try to separate those into:

```Shell
yarn build:ui
yarn build:server
# OR
npm run build:ui
npm run build:server
```

when you need to override a package.json. It's nice to use the one from the upstream src and do some explicit override. Here is an example.

```nix
patchedPackageJSON = final.runCommand "package.json" { } ''
  ${jq}/bin/jq '.version = "0.4.0" |
    .devDependencies."@jsdoc/cli" = "^0.2.5"
    ${sonar-src}/package.json > $out
'';
```

you will still need to commit the modified version of the lock files, but at least the overrides are explicit for everyone to see.

### Using node_modules directly {#javascript-using-node_modules}

each tool has an abstraction to just build the node_modules (dependencies) directory. you can always use the stdenv.mkDerivation with the node_modules to build the package (symlink the node_modules directory and then use the package build command). the node_modules abstraction can be also used to build some web framework frontends. For an example of this see how [plausible](https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/web-apps/plausible/default.nix) is built. mkYarnModules to make the derivation containing node_modules. Then when building the frontend you can just symlink the node_modules directory

## Javascript packages inside nixpkgs {#javascript-packages-nixpkgs}

The `pkgs/development/node-packages` folder contains a generated collection of
[NPM packages](https://npmjs.com/) that can be installed with the Nix package
manager.

As a rule of thumb, the package set should only provide _end user_ software
packages, such as command-line utilities. Libraries should only be added to the
package set if there is a non-NPM package that requires it.

When it is desired to use NPM libraries in a development project, use the
`node2nix` generator directly on the `package.json` configuration file of the
project.

The package set provides support for the official stable Node.js versions.
The latest stable LTS release in `nodePackages`, as well as the latest stable
Current release in `nodePackages_latest`.

If your package uses native addons, you need to examine what kind of native
build system it uses. Here are some examples:

- `node-gyp`
- `node-gyp-builder`
- `node-pre-gyp`

After you have identified the correct system, you need to override your package
expression while adding in build system as a build input. For example, `dat`
requires `node-gyp-build`, so [we override](https://github.com/NixOS/nixpkgs/blob/32f5e5da4a1b3f0595527f5195ac3a91451e9b56/pkgs/development/node-packages/default.nix#L37-L40) its expression in [`default.nix`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/node-packages/default.nix):

```nix
    dat = super.dat.override {
      buildInputs = [ self.node-gyp-build pkgs.libtool pkgs.autoconf pkgs.automake ];
      meta.broken = since "12";
    };
```

### Adding and Updating Javascript packages in nixpkgs

To add a package from NPM to nixpkgs:

1. Modify `pkgs/development/node-packages/node-packages.json` to add, update
    or remove package entries to have it included in `nodePackages` and
    `nodePackages_latest`.
2. Run the script: `./pkgs/development/node-packages/generate.sh`.
3. Build your new package to test your changes:
    `cd /path/to/nixpkgs && nix-build -A nodePackages.<new-or-updated-package>`.
    To build against the latest stable Current Node.js version (e.g. 14.x):
    `nix-build -A nodePackages_latest.<new-or-updated-package>`
4. Add and commit all modified and generated files.

For more information about the generation process, consult the
[README.md](https://github.com/svanderburg/node2nix) file of the `node2nix`
tool.

To update NPM packages in nixpkgs, run the same `generate.sh` script:

```sh
./pkgs/development/node-packages/generate.sh
```

#### Git protocol error

Some packages may have Git dependencies from GitHub specified with `git://`.
GitHub has
[disabled unecrypted Git connections](https://github.blog/2021-09-01-improving-git-protocol-security-github/#no-more-unauthenticated-git),
so you may see the following error when running the generate script:
`The unauthenticated git protocol on port 9418 is no longer supported`.

Use the following Git configuration to resolve the issue:

```sh
git config --global url."https://github.com/".insteadOf git://github.com/
```

## Tool specific instructions {#javascript-tool-specific}

### node2nix {#javascript-node2nix}

#### Preparation {#javascript-node2nix-preparation}

you will need to generate a nix expression for the dependencies

- don't forget the `-l package-lock.json` if there is a lock file
- Most probably you will need the `--development` to include the `devDependencies`

so the command will most likely be
`node2nix --development -l package-lock.json`

[link to the doc in the repo](https://github.com/svanderburg/node2nix)

#### Pitfalls {#javascript-node2nix-pitfalls}

- if upstream package.json does not have a "version" attribute, node2nix will crash. You will need to add it like shown in [the package.json section](#javascript-upstream-package-json)
- node2nix has some [bugs](https://github.com/svanderburg/node2nix/issues/238). related to working with lock files from npm distributed with nodejs-16_x
- node2nix does not like missing packages from npm. If you see something like `Cannot resolve version: vue-loader-v16@undefined` then you might want to try another tool. The package might have been pulled off of npm.

### yarn2nix {#javascript-yarn2nix}

#### Preparation {#javascript-yarn2nix-preparation}

you will need at least a yarn.lock and yarn.nix file

- generate a yarn.lock in upstream if it is not already there
- `yarn2nix > yarn.nix` will generate the dependencies in a nix format

#### mkYarnPackage {#javascript-yarn2nix-mkYarnPackage}

this will by default try to generate a binary. For package only generating static assets (Svelte, Vue, React...), you will need to explicitly override the build step with your instructions. It's important to use the `--offline` flag. For example if you script is `"build": "something"` in package.json use

```nix
buildPhase = ''
  yarn build --offline
'';
```

The dist phase is also trying to build a binary, the only way to override it is with

```nix
distPhase = "true";
```

the configure phase can sometimes fail because it tries to be too clever.
One common override is

```nix
configurePhase = "ln -s $node_modules node_modules";
```

#### mkYarnModules {#javascript-yarn2nix-mkYarnModules}

this will generate a derivation including the node_modules. If you have to build a derivation for an integrated web framework (rails, phoenix..), this is probably the easiest way. [Plausible](https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/web-apps/plausible/default.nix#L39) offers a good example of how to do this.

#### Overriding dependency behavior

In the `mkYarnPackage` record the property `pkgConfig` can be used to override packages when you encounter problems building.

For instance, say your package is throwing errors when trying to invoke node-sass: `ENOENT: no such file or directory, scandir '/build/source/node_modules/node-sass/vendor'`

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

- if version is missing from upstream package.json, yarn will silently install nothing. In that case, you will need to override package.json as shown in the [package.json section](#javascript-upstream-package-json)

- having trouble with node-gyp? Try adding these lines to the `yarnPreBuild` steps:

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

## Outside of nixpkgs {#javascript-outside-nixpkgs}

There are some other options available that can't be used inside nixpkgs. Those other options are written in nix. Importing them in nixpkgs will require moving the source code into nixpkgs. Using [Import From Derivation](https://nixos.wiki/wiki/Import_From_Derivation) is not allowed in hydra at present. If you are packaging something outside nixpkgs, those can be considered

### npmlock2nix {#javascript-npmlock2nix}

[npmlock2nix](https://github.com/nix-community/npmlock2nix) aims at building node_modules without code generation. It hasn't reached v1 yet, the api might be subject to change.

#### Pitfalls {#javascript-npmlock2nix-pitfalls}

- there are some [problems with npm v7](https://github.com/tweag/npmlock2nix/issues/45).

### nix-npm-buildpackage {#javascript-nix-npm-buildpackage}

[nix-npm-buildpackage](https://github.com/serokell/nix-npm-buildpackage) aims at building node_modules without code generation. It hasn't reached v1 yet, the api might change. It supports both package-lock.json and yarn.lock.

#### Pitfalls {#javascript-nix-npm-buildpackage-pitfalls}

- there are some [problems with npm v7](https://github.com/serokell/nix-npm-buildpackage/issues/33).
