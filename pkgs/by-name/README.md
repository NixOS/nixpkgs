# Name-based package directories

The structure of this directory maps almost directly to top-level package attributes.
Add new top-level packages to Nixpkgs using this mechanism [whenever possible](#limitations).

Packages found in the name-based structure are automatically included, without needing to be added to `all-packages.nix`. However if the implicit attribute defaults need to be changed for a package, this [must still be declared in `all-packages.nix`](#changing-implicit-attribute-defaults).

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
{
  libfoo = callPackage ../by-name/so/some-package/package.nix {
    libbar = libbar_2;
  };
}
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

CI performs [certain checks](https://github.com/NixOS/nixpkgs-check-by-name?tab=readme-ov-file#validity-checks) on the `pkgs/by-name` structure.
This is done using the [`nixpkgs-check-by-name` tool](https://github.com/NixOS/nixpkgs-check-by-name).

You can locally emulate the CI check using

```
$ ./maintainers/scripts/check-by-name.sh master
```

See [here](../../.github/workflows/check-by-name.yml) for more info.

## Recommendation for new packages with multiple versions

These checks of the `pkgs/by-name` structure can cause problems in combination:
1. New top-level packages using `callPackage` must be defined via `pkgs/by-name`.
2. Packages in `pkgs/by-name` cannot refer to files outside their own directory.

This means that outside `pkgs/by-name`, multiple already-present top-level packages can refer to some common file.
If you open a PR to another instance of such a package, CI will fail check 1,
but if you try to move the package to `pkgs/by-name`, it will fail check 2.

This is often the case for packages with multiple versions, such as

```nix
{
  foo_1 = callPackage ../tools/foo/1.nix { };
  foo_2 = callPackage ../tools/foo/2.nix { };
}
```

The best way to resolve this is to not use `callPackage` directly, such that check 1 doesn't trigger.
This can be done by using `inherit` on a local package set:
```nix
{
  inherit
    ({
      foo_1 = callPackage ../tools/foo/1.nix { };
      foo_2 = callPackage ../tools/foo/2.nix { };
    })
    foo_1
    foo_2
    ;
}
```

While this may seem pointless, this can in fact help with future package set refactorings,
because it establishes a clear connection between related attributes.

### Further possible refactorings

This is not required, but the above solution also allows refactoring the definitions into a separate file:

```nix
{
  inherit (import ../tools/foo pkgs)
    foo_1 foo_2;
}
```

```nix
# pkgs/tools/foo/default.nix
pkgs: {
  foo_1 = callPackage ./1.nix { };
  foo_2 = callPackage ./2.nix { };
}
```

Alternatively using [`callPackages`](https://nixos.org/manual/nixpkgs/unstable/#function-library-lib.customisation.callPackagesWith)
if `callPackage` isn't used underneath and you want the same `.override` arguments for all attributes:

```nix
{
  inherit (callPackages ../tools/foo { })
    foo_1 foo_2;
}
```

```nix
# pkgs/tools/foo/default.nix
{
  stdenv
}: {
  foo_1 = stdenv.mkDerivation { /* ... */ };
  foo_2 = stdenv.mkDerivation { /* ... */ };
}
```

### Exposing the package set

This is not required, but the above solution also allows exposing the package set as an attribute:

```nix
{
  foo-versions = import ../tools/foo pkgs;
  # Or using callPackages
  # foo-versions = callPackages ../tools/foo { };

  inherit (foo-versions) foo_1 foo_2;
}
```
