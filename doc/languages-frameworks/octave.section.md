# Octave {#sec-octave}

## Introduction {#ssec-octave-introduction}

Octave is a modular scientific programming language and environment.
A majority of the packages supported by Octave from their [website](https://gnu-octave.github.io/packages/) are packaged in nixpkgs.

## Structure {#ssec-octave-structure}

All Octave add-on packages are available in two ways:
1. Under the top-level `Octave` attribute, `octave.pkgs`.
2. As a top-level attribute, `octavePackages`.

## Packaging Octave Packages {#ssec-octave-packaging}

Nixpkgs provides a function `buildOctavePackage`, a generic package builder function for any Octave package that complies with the Octave's current packaging format.

All Octave packages are defined in [pkgs/top-level/octave-packages.nix](https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/octave-packages.nix) rather than `pkgs/all-packages.nix`.
Each package is defined in its own file in the [pkgs/development/octave-modules](https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/octave-modules) directory.
Octave packages are made available through `all-packages.nix` through both the attribute `octavePackages` and `octave.pkgs`.
You can test building an Octave package as follows:

```ShellSession
$ nix-build -A octavePackages.symbolic
```

To install it into your user profile, run this command from the root of the repository:

```ShellSession
$ nix-env -f. -iA octavePackages.symbolic
```

You can build Octave with packages by using the `withPackages` passed-through function.

```ShellSession
$ nix-shell -p 'octave.withPackages (ps: with ps; [ symbolic ])'
```

This will also work in a `shell.nix` file.

```nix
{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [ (octave.withPackages (opkgs: with opkgs; [ symbolic ])) ];
}
```

### `buildOctavePackage` Steps {#sssec-buildOctavePackage-steps}

The `buildOctavePackage` does several things to make sure things work properly.

1. Sets the environment variable `OCTAVE_HISTFILE` to `/dev/null` during package compilation so that the commands run through the Octave interpreter directly are not logged.
2. Skips the configuration step, because the packages are stored as gzipped tarballs, which Octave itself handles directly.
3. Changes the hierarchy of the tarball so that only a single directory is at the top-most level of the tarball.
4. Use Octave itself to run the `pkg build` command, which unzips the tarball, extracts the necessary files written in Octave, and compiles any code written in C++ or Fortran, and places the fully compiled artifact in `$out`.

`buildOctavePackage` is built on top of `stdenv` in a standard way, allowing most things to be customized.

### Handling Dependencies {#sssec-octave-handling-dependencies}

In Octave packages, there are four sets of dependencies that can be specified:

`nativeBuildInputs`
: Just like other packages, `nativeBuildInputs` is intended for architecture-dependent build-time-only dependencies.

`buildInputs`
: Like other packages, `buildInputs` is intended for architecture-independent build-time-only dependencies.

`propagatedBuildInputs`
: Similar to other packages, `propagatedBuildInputs` is intended for packages that are required for both building and running of the package.
See [Symbolic](https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/octave-modules/symbolic/default.nix) for how this works and why it is needed.

`requiredOctavePackages`
: This is a special dependency that ensures the specified Octave packages are dependent on others, and are made available simultaneously when loading them in Octave.

### Installing Octave Packages {#sssec-installing-octave-packages}

By default, the `buildOctavePackage` function does _not_ install the requested package into Octave for use.
The function will only build the requested package.
This is due to Octave maintaining a text-based database about which packages are installed where.
To this end, when all the requested packages have been built, the Octave package and all its add-on packages are put together into an environment, similar to Python.

1. First, all the Octave binaries are wrapped with the environment variable `OCTAVE_SITE_INITFILE` set to a file in `$out`, which is required for Octave to be able to find the non-standard package database location.
2. Because of the way `buildEnv` works, all tarballs that are present (which should be all Octave packages to install) should be removed.
3. The path down to the default install location of Octave packages is recreated so that Nix-operated Octave can install the packages.
4. Install the packages into the `$out` environment while writing package entries to the database file.
This database file is unique for each different (according to Nix) environment invocation.
5. Rewrites the Octave-wide startup file to read from the list of packages installed in that particular environment.
6. Wrap any programs that are required by the Octave packages so that they work with all the paths defined within the environment.
