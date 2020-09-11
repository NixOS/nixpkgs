---
title: Agda
author: Alex Rice (alexarice)
date: 2020-01-06
---
# Agda

## How to use Agda

Agda can be installed from `agda`:
```
$ nix-env -iA agda
```

To use agda with libraries, the `agda.withPackages` function can be used. This function either takes:
+ A list of packages,
+ or a function which returns a list of packages when given the `agdaPackages` attribute set,
+ or an attribute set containing a list of packages and a GHC derivation for compilation (see below).

For example, suppose we wanted a version of agda which has access to the standard library. This can be obtained with the expressions:

```
agda.withPackages [ agdaPackages.standard-library ]
```

or

```
agda.withPackages (p: [ p.standard-library ])
```

or can be called as in the [Compiling Agda](#compiling-agda) section.

If you want to use a library in your home directory (for instance if it is a development version) then typecheck it manually (using `agda.withPackages` if necessary) and then override the `src` attribute of the package to point to your local repository.

Agda will not by default use these libraries. To tell agda to use the library we have some options:
- Call `agda` with the library flag:
```
$ agda -l standard-library -i . MyFile.agda
```
- Write a `my-library.agda-lib` file for the project you are working on which may look like:
```
name: my-library
include: .
depend: standard-library
```
- Create the file `~/.agda/defaults` and add any libraries you want to use by default.

More information can be found in the [official Agda documentation on library management](https://agda.readthedocs.io/en/v2.6.1/tools/package-system.html).

## Compiling Agda
Agda modules can be compiled with the `--compile` flag. A version of `ghc` with `ieee` is made available to the Agda program via the `--with-compiler` flag.
This can be overridden by a different version of `ghc` as follows:

```
agda.withPackages {
  pkgs = [ ... ];
  ghc = haskell.compiler.ghcHEAD;
}
```

## Writing Agda packages
To write a nix derivation for an agda library, first check that the library has a `*.agda-lib` file.

A derivation can then be written using `agdaPackages.mkDerivation`. This has similar arguments to `stdenv.mkDerivation` with the following additions:
+ `everythingFile` can be used to specify the location of the `Everything.agda` file, defaulting to `./Everything.agda`. If this file does not exist then either it should be patched in or the `buildPhase` should be overridden (see below).
+ `libraryName` should be the name that appears in the `*.agda-lib` file, defaulting to `pname`.
+ `libraryFile` should be the file name of the `*.agda-lib` file, defaulting to `${libraryName}.agda-lib`.

### Building Agda packages
The default build phase for `agdaPackages.mkDerivation` simply runs `agda` on the `Everything.agda` file.
If something else is needed to build the package (e.g. `make`) then the `buildPhase` should be overridden.
Additionally, a `preBuild` or `configurePhase` can be used if there are steps that need to be done prior to checking the `Everything.agda` file.
`agda` and the Agda libraries contained in `buildInputs` are made available during the build phase.

### Installing Agda packages
The default install phase copies agda source files, agda interface files (`*.agdai`) and `*.agda-lib` files to the output directory.
This can be overridden.

By default, agda sources are files ending on  `.agda`, or literate agda files ending on `.lagda`, `.lagda.tex`, `.lagda.org`, `.lagda.md`, `.lagda.rst`. The list of recognised agda source extensions can be extended by setting the `extraExtensions` config variable.

To add an agda package to `nixpkgs`, the derivation should be written to `pkgs/development/libraries/agda/${library-name}/` and an entry should be added to `pkgs/top-level/agda-packages.nix`. Here it is called in a scope with access to all other agda libraries, so the top line of the `default.nix` can look like:
```
{ mkDerivation, standard-library, fetchFromGitHub }:
```
and `mkDerivation` should be called instead of `agdaPackages.mkDerivation`. Here is an example skeleton derivation for iowa-stdlib:

```
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

When writing an agda package it is essential to make sure that no `.agda-lib` file gets added to the store as a single file (for example by using `writeText`). This causes agda to think that the nix store is a agda library and it will attempt to write to it whenever it typechecks something. See [https://github.com/agda/agda/issues/4613](https://github.com/agda/agda/issues/4613).
