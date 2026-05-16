# Agda {#agda}

## How to use Agda {#how-to-use-agda}

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
    src = fetchFromGitHub {
      repo = "agda-stdlib";
      owner = "agda";
      rev = "v1.5";
      hash = "sha256-nEyxYGSWIDNJqBfGpRDLiOAnlHJKEKAOMnIaqfVZzJk=";
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
      hash = "...";
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

## Compiling Agda {#compiling-agda}

Agda modules can be compiled using the GHC backend with the `--compile` flag. A version of `ghc` with `ieee754` is made available to the Agda program via the `--with-compiler` flag.
This can be overridden by a different version of `ghc` as follows:

```nix
agda.withPackages {
  pkgs = [
    # ...
  ];
  ghc = haskell.compiler.ghcHEAD;
}
```

To install Agda without GHC, use `ghc = null;`.

## Writing Agda packages {#writing-agda-packages}

To write a nix derivation for an Agda library, first check that the library has a (single) `*.agda-lib` file.

A derivation can then be written using `agdaPackages.mkDerivation`. This has similar arguments to `stdenv.mkDerivation` with the following additions:

* `libraryName` should be the name that appears in the `*.agda-lib` file, defaulting to `pname`.
* `libraryFile` should be the file name of the `*.agda-lib` file, defaulting to `${libraryName}.agda-lib`.

Here is an example `default.nix`

```nix
{
  nixpkgs ? <nixpkgs>,
}:
with (import nixpkgs { });
agdaPackages.mkDerivation {
  version = "1.0";
  pname = "my-agda-lib";
  src = ./.;
  buildInputs = [ agdaPackages.standard-library ];
}
```

### Building Agda packages {#building-agda-packages}

The default build phase for `agdaPackages.mkDerivation` runs `agda --build-library`.
If something else is needed to build the package (e.g. `make`) then the `buildPhase` should be overridden.
Additionally, a `preBuild` or `configurePhase` can be used if there are steps that need to be done prior to checking the library.
`agda` and the Agda libraries contained in `buildInputs` are made available during the build phase.

### Installing Agda packages {#installing-agda-packages}

The default install phase copies Agda source files, Agda interface files (`*.agdai`) and `*.agda-lib` files to the output directory.
This can be overridden.

By default, Agda sources are files ending on `.agda`, or literate Agda files ending on `.lagda`, `.lagda.tex`, `.lagda.org`, `.lagda.md`, `.lagda.rst`. The list of recognised Agda source extensions can be extended by setting the `extraExtensions` config variable.

## Maintaining the Agda package set on Nixpkgs {#maintaining-the-agda-package-set-on-nixpkgs}

We are aiming at providing all common Agda libraries as packages on `nixpkgs`,
and keeping them up to date.
Contributions and maintenance help is always appreciated,
but the maintenance effort is typically low since the Agda ecosystem is quite small.

The `nixpkgs` Agda package set tries to take up a role similar to that of [Stackage](https://www.stackage.org/) in the Haskell world.
It is a curated set of libraries that:

1. Always work together.
2. Are as up-to-date as possible.

While the Haskell ecosystem is huge, and Stackage is highly automated,
the Agda package set is small and can (still) be maintained by hand.

### Adding Agda packages to Nixpkgs {#adding-agda-packages-to-nixpkgs}

To add an Agda package to `nixpkgs`, the derivation should be written to `pkgs/development/libraries/agda/${library-name}/default.nix` and an entry should be added to `pkgs/top-level/agda-packages.nix`. Here it is called in a scope with access to all other Agda libraries, so the derivation could look like:

```nix
{
  mkDerivation,
  standard-library,
  fetchFromGitHub,
}:

mkDerivation {
  pname = "my-library";
  version = "1.0";
  src = <...>;
  buildInputs = [ standard-library ];
  meta = <...>;
}
```

You can look at other files under `pkgs/development/libraries/agda/` for more inspiration.

Note that the derivation function is called with `mkDerivation` set to `agdaPackages.mkDerivation`, therefore you
could use a similar set as in your `default.nix` from [Writing Agda Packages](#writing-agda-packages) with
`agdaPackages.mkDerivation` replaced with `mkDerivation`.

Here is an example skeleton derivation for iowa-stdlib:

```nix
mkDerivation {
  version = "1.5.0";
  pname = "iowa-stdlib";

  src = <...>;

  libraryFile = "";
  libraryName = "IAL-1.3";

  buildPhase = ''
    runHook preBuild

    patchShebangs find-deps.sh
    make

    runHook postBuild
  '';
}
```

This library has a file called `.agda-lib`, and so we give an empty string to `libraryFile` as nothing precedes `.agda-lib` in the filename. This file contains `name: IAL-1.3`, and so we let `libraryName =  "IAL-1.3"`. This library does not use an `Everything.agda` file and instead has a Makefile, so there is no need to set `everythingFile` and we set a custom `buildPhase`.

When writing an Agda package, it is essential to make sure that no `.agda-lib` file gets added to the store as a single file (for example by using `writeText`). This causes Agda to think that the nix store is a Agda library and it will attempt to write to it whenever it typechecks something. See [https://github.com/agda/agda/issues/4613](https://githcub.com/agda/agda/issues/4613).

In the pull request adding this library,
you can test whether it builds correctly by writing in a comment:

```
@ofborg build agdaPackages.my-library
```

### Maintaining Agda packages {#agda-maintaining-packages}

As mentioned before, the aim is to have a compatible, and up-to-date package set.
These two conditions sometimes exclude each other:
For example, if we update `agdaPackages.standard-library` because there was an upstream release,
this will typically break many reverse dependencies,
i.e. downstream Agda libraries that depend on the standard library.
In `nixpkgs` we are typically among the first to notice this,
since we have build tests in place to check this.

In a pull request updating e.g. the standard library, you should write the following comment:

```
@ofborg build agdaPackages.standard-library.passthru.tests
```

This will build all reverse dependencies of the standard library,
for example `agdaPackages.agda-categories`.

In some cases it is useful to build _all_ Agda packages.
This can be done with the following Github comment:

```
@ofborg build agda.passthru.tests.allPackages
```

Sometimes, the builds of the reverse dependencies fail because they have not yet been updated and released.
You should drop the maintainers a quick issue notifying them of the breakage,
citing the build error (which you can get from the ofborg logs).
If you are motivated, you might even send a pull request that fixes it.
Usually, the maintainers will answer within a week or two with a new release.
Bumping the version of that reverse dependency should be a further commit on your PR.

In the rare case that a new release is not to be expected within an acceptable time,
mark the broken package as broken by setting `meta.broken = true;`.
This will exclude it from the build test.
It can be added later when it is fixed,
and does not hinder the advancement of the whole package set in the meantime.
