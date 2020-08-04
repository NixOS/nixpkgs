Node.js
=======
The `pkgs/development/node-packages` folder contains a generated collection of
[NPM packages](https://npmjs.com/) that can be installed with the Nix package
manager.

As a rule of thumb, the package set should only provide *end user* software
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

* `node-gyp`
* `node-gyp-builder`
* `node-pre-gyp`

After you have identified the correct system, you need to override your package
expression while adding in build system as a build input. For example, `dat`
requires `node-gyp-build`, so we override its expression in `default.nix`:

```nix
dat = nodePackages.dat.override (oldAttrs: {
  buildInputs = oldAttrs.buildInputs ++ [ nodePackages.node-gyp-build ];
});
```

To add a package from NPM to nixpkgs:

 1. Modify `pkgs/development/node-packages/node-packages.json` to add, update
    or remove package entries to have it included in `nodePackages` and
    `nodePackages_latest`.
 2. Run the script: `(cd pkgs/development/node-packages && ./generate.sh)`.
 3. Build your new package to test your changes:
    `cd /path/to/nixpkgs && nix-build -A nodePackages.<new-or-updated-package>`.
    To build against the latest stable Current Node.js version (e.g. 14.x):
    `nix-build -A nodePackages_latest.<new-or-updated-package>`
 4. Add and commit all modified and generated files.

For more information about the generation process, consult the
[README.md](https://github.com/svanderburg/node2nix) file of the `node2nix`
tool.
