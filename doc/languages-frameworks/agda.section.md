# Agda {#agda}

## How to use Agda

Agda is available as the [agda](https://search.nixos.org/packages?channel=unstable&show=agda&from=0&size=30&sort=relevance&query=agda)
package.

The `agda` package installs an Agda-wrapper, which calls `agda` with `--library-file`
set to a generated library-file within the nix store, this means your library-file in
`$HOME/.agda/libraries` will be ignored. By default the agda package installs Agda
with no libraries, i.e. the generated library-file is empty. To use Agda with libraries,
the `agda.withPackages` function can be used. This function either takes:

* A list of packages,
* or a function which returns a list of packages when given the `agdaPackages` attribute set,
* or an attribute set containing a list of packages and a GHC derivation for compilation (see below).
* or an attribute set containing a function which returns a list of packages when given the `agdaPackages` attribute set and a GHC derivation for compilation (see below).

For example, suppose we wanted a version of Agda which has access to the standard library. This can be obtained with the expressions:

```nix
agda.withPackages [ agdaPackages.standard-library ]
```

or

```nix
agda.withPackages (p: [ p.standard-library ])
```

or can be called as in the [Compiling Agda](#compiling-agda) section.

If you want to use a different version of a library (for instance a development version)
override the `src` attribute of the package to point to your local repository

```nix
agda.withPackages (p: [
  (p.standard-library.overrideAttrs (oldAttrs: {
    version = "local version";
    src = /path/to/local/repo/agda-stdlib;
  }))
])
```

You can also reference a GitHub repository
```nix
agda.withPackages (p: [
  (p.standard-library.overrideAttrs (oldAttrs: {
    version = "1.5";
    src =  fetchFromGitHub {
      repo = "agda-stdlib";
      owner = "agda";
      rev = "v1.5";
      sha256 = "16fcb7ssj6kj687a042afaa2gq48rc8abihpm14k684ncihb2k4w";
    };
  }))
])
```

If you want to use a library not added to Nixpkgs, you can add a
dependency to a local library by calling `agdaPackages.mkDerivation`.
```nix
agda.withPackages (p: [
  (p.mkDerivation {
    pname = "your-agda-lib";
    version = "1.0.0";
    src = /path/to/your-agda-lib;
  })
])
```

Again you can reference GitHub

```nix
agda.withPackages (p: [
  (p.mkDerivation {
    pname = "your-agda-lib";
    version = "1.0.0";
    src = fetchFromGitHub {
      repo = "repo";
      owner = "owner";
      version = "...";
      rev = "...";
      sha256 = "...";
    };
  })
])
```

See [Building Agda Packages](#building-agda-packages) for more information on `mkDerivation`.

Agda will not by default use these libraries. To tell Agda to use a library we have some options:

* Call `agda` with the library flag:
```ShellSession
$ agda -l standard-library -i . MyFile.agda
```
* Write a `my-library.agda-lib` file for the project you are working on which may look like:
```
name: my-library
include: .
depend: standard-library
```
* Create the file `~/.agda/defaults` and add any libraries you want to use by default.

More information can be found in the [official Agda documentation on library management](https://agda.readthedocs.io/en/v2.6.1/tools/package-system.html).

## Compiling Agda
Agda modules can be compiled using the GHC backend with the `--compile` flag. A version of `ghc` with `ieee754` is made available to the Agda program via the `--with-compiler` flag.
This can be overridden by a different version of `ghc` as follows:

```nix
agda.withPackages {
  pkgs = [ ... ];
  ghc = haskell.compiler.ghcHEAD;
}
```

## Writing Agda packages
To write a nix derivation for an Agda library, first check that the library has a `*.agda-lib` file.

A derivation can then be written using `agdaPackages.mkDerivation`. This has similar arguments to `stdenv.mkDerivation` with the following additions:

* `everythingFile` can be used to specify the location of the `Everything.agda` file, defaulting to `./Everything.agda`. If this file does not exist then either it should be patched in or the `buildPhase` should be overridden (see below).
* `libraryName` should be the name that appears in the `*.agda-lib` file, defaulting to `pname`.
* `libraryFile` should be the file name of the `*.agda-lib` file, defaulting to `${libraryName}.agda-lib`.

Here is an example `default.nix`

```nix
{ nixpkgs ?  <nixpkgs> }:
with (import nixpkgs {});
agdaPackages.mkDerivation {
  version = "1.0";
  pname = "my-agda-lib";
  src = ./.;
  buildInputs = [
    agdaPackages.standard-library
  ];
}
```

### Building Agda packages
The default build phase for `agdaPackages.mkDerivation` simply runs `agda` on the `Everything.agda` file.
If something else is needed to build the package (e.g. `make`) then the `buildPhase` should be overridden.
Additionally, a `preBuild` or `configurePhase` can be used if there are steps that need to be done prior to checking the `Everything.agda` file.
`agda` and the Agda libraries contained in `buildInputs` are made available during the build phase.

### Installing Agda packages
The default install phase copies Agda source files, Agda interface files (`*.agdai`) and `*.agda-lib` files to the output directory.
This can be overridden.

By default, Agda sources are files ending on `.agda`, or literate Agda files ending on `.lagda`, `.lagda.tex`, `.lagda.org`, `.lagda.md`, `.lagda.rst`. The list of recognised Agda source extensions can be extended by setting the `extraExtensions` config variable.

## Adding Agda packages to Nixpkgs

To add an Agda package to `nixpkgs`, the derivation should be written to `pkgs/development/libraries/agda/${library-name}/` and an entry should be added to `pkgs/top-level/agda-packages.nix`. Here it is called in a scope with access to all other Agda libraries, so the top line of the `default.nix` can look like:

```nix
{ mkDerivation, standard-library, fetchFromGitHub }:
```

Note that the derivation function is called with `mkDerivation` set to `agdaPackages.mkDerivation`, therefore you
could use a similar set as in your `default.nix` from [Writing Agda Packages](#writing-agda-packages) with
`agdaPackages.mkDerivation` replaced with `mkDerivation`.

Here is an example skeleton derivation for iowa-stdlib:

```nix
mkDerivation {
  version = "1.5.0";
  pname = "iowa-stdlib";

  src = ...

  libraryFile = "";
  libraryName = "IAL-1.3";

  buildPhase = ''
    patchShebangs find-deps.sh
    make
  '';
}
```
This library has a file called `.agda-lib`, and so we give an empty string to `libraryFile` as nothing precedes `.agda-lib` in the filename. This file contains `name: IAL-1.3`, and so we let `libraryName =  "IAL-1.3"`. This library does not use an `Everything.agda` file and instead has a Makefile, so there is no need to set `everythingFile` and we set a custom `buildPhase`.

When writing an Agda package it is essential to make sure that no `.agda-lib` file gets added to the store as a single file (for example by using `writeText`). This causes Agda to think that the nix store is a Agda library and it will attempt to write to it whenever it typechecks something. See [https://github.com/agda/agda/issues/4613](https://github.com/agda/agda/issues/4613).
