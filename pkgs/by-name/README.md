# Name-based package directories

The structure of this directory maps almost directly to top-level package attributes.
This is the recommended way to add new top-level packages to Nixpkgs [when possible](#limitations).

Packages found in the named-based structure do not need to be explicitly added to the
`top-level/all-packages.nix` file unless they require overriding the default value
of an implicit attribute (see below).

## Example

The top-level package `pkgs.some-package` may be declared by setting up this file structure:

```
pkgs
└── by-name
   ├── so
   ┊  ├── some-package
      ┊  └── package.nix

```

Where `some-package` is the package name and `so` is the lowercased 2-letter prefix of the package name.

The `package.nix` may look like this:

```nix
# A function taking an attribute set as an argument
{
  # Get access to top-level attributes for use as dependencies
  lib,
  stdenv,
  libbar,

  # Make this derivation configurable using `.override { enableBar = true }`
  enableBar ? false,
}:

# The return value must be a derivation
stdenv.mkDerivation {
  # ...
  buildInputs =
    lib.optional enableBar libbar;
}
```

You can also split up the package definition into more files in the same directory if necessary.

Once defined, the package can be built from the Nixpkgs root directory using:
```
nix-build -A some-package
```

See the [general package conventions](../README.md#conventions) for more information on package definitions.

### Changing implicit attribute defaults

The above expression is called using these arguments by default:
```nix
{
  lib = pkgs.lib;
  stdenv = pkgs.stdenv;
  libbar = pkgs.libbar;
}
```

But the package might need `pkgs.libbar_2` instead.
While the function could be changed to take `libbar_2` directly as an argument,
this would change the `.override` interface, breaking code like `.override { libbar = ...; }`.
So instead it is preferable to use the same generic parameter name `libbar`
and override its value in [`pkgs/top-level/all-packages.nix`](../top-level/all-packages.nix):

```nix
libfoo = callPackage ../by-name/so/some-package/package.nix {
  libbar = libbar_2;
};
```

## Manual migration guidelines

Most packages are still defined in `all-packages.nix` and the [category hierarchy](../README.md#category-hierarchy).
Please hold off migrating your maintained packages to this directory.

1. An automated migration for the majority of packages [is being worked on](https://github.com/NixOS/nixpkgs/pull/211832).
   In order to save on contributor and reviewer time, packages should only be migrated manually afterwards if they couldn't be migrated automatically.

1. Manual migrations should only be lightly encouraged if the relevant code is being worked on anyways.
   For example with a package update or refactoring.

1. Manual migrations should not remove definitions from `all-packages.nix` with custom arguments.
   That is a backwards-incompatible change because it changes the `.override` interface.
   Such packages may still be moved to `pkgs/by-name` however, while keeping the definition in `all-packages.nix`.
   See also [changing implicit attribute defaults](#changing-implicit-attribute-defaults).

## Limitations

There's some limitations as to which packages can be defined using this structure:

- Only packages defined using `pkgs.callPackage`.
  This excludes packages defined using `pkgs.python3Packages.callPackage ...`.

  Instead:
  - Either change the package definition to work with `pkgs.callPackage`.
  - Or use the [category hierarchy](../README.md#category-hierarchy).

- Only top-level packages.
  This excludes packages for other package sets like `pkgs.pythonPackages.*`.

  Refer to the definition and documentation of the respective package set to figure out how such packages can be declared.

## Validation

CI performs [certain checks](../test/nixpkgs-check-by-name/README.md#validity-checks) on the `pkgs/by-name` structure.
This is done using the [`nixpkgs-check-by-name` tool](../test/nixpkgs-check-by-name).

You can locally emulate the CI check using

```
$ ./pkgs/test/nixpkgs-check-by-name/scripts/run-local.sh master
```

See [here](../../.github/workflows/check-by-name.yml) for more info.
