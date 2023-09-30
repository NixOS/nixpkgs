# Dhall {#sec-language-dhall}

The Nixpkgs support for Dhall assumes some familiarity with Dhall's language
support for importing Dhall expressions, which is documented here:

* [`dhall-lang.org` - Installing packages](https://docs.dhall-lang.org/tutorials/Language-Tour.html#installing-packages)

## Remote imports {#ssec-dhall-remote-imports}

Nixpkgs bypasses Dhall's support for remote imports using Dhall's
semantic integrity checks.  Specifically, any Dhall import can be protected by
an integrity check like:

```dhall
https://prelude.dhall-lang.org/v20.1.0/package.dhall
  sha256:26b0ef498663d269e4dc6a82b0ee289ec565d683ef4c00d0ebdd25333a5a3c98
```

… and if the import is cached then the interpreter will load the import from
cache instead of fetching the URL.

Nixpkgs uses this trick to add all of a Dhall expression's dependencies into the
cache so that the Dhall interpreter never needs to resolve any remote URLs.  In
fact, Nixpkgs uses a Dhall interpreter with remote imports disabled when
packaging Dhall expressions to enforce that the interpreter never resolves a
remote import.  This means that Nixpkgs only supports building Dhall expressions
if all of their remote imports are protected by semantic integrity checks.

Instead of remote imports, Nixpkgs uses Nix to fetch remote Dhall code.  For
example, the Prelude Dhall package uses `pkgs.fetchFromGitHub` to fetch the
`dhall-lang` repository containing the Prelude.  Relying exclusively on Nix
to fetch Dhall code ensures that Dhall packages built using Nix remain pure and
also behave well when built within a sandbox.

## Packaging a Dhall expression from scratch {#ssec-dhall-packaging-expression}

We can illustrate how Nixpkgs integrates Dhall by beginning from the following
trivial Dhall expression with one dependency (the Prelude):

```dhall
-- ./true.dhall

let Prelude = https://prelude.dhall-lang.org/v20.1.0/package.dhall

in  Prelude.Bool.not False
```

As written, this expression cannot be built using Nixpkgs because the
expression does not protect the Prelude import with a semantic integrity
check, so the first step is to freeze the expression using `dhall freeze`,
like this:

```ShellSession
$ dhall freeze --inplace ./true.dhall
```

… which gives us:

```dhall
-- ./true.dhall

let Prelude =
      https://prelude.dhall-lang.org/v20.1.0/package.dhall
        sha256:26b0ef498663d269e4dc6a82b0ee289ec565d683ef4c00d0ebdd25333a5a3c98

in  Prelude.Bool.not False
```

To package that expression, we create a `./true.nix` file containing the
following specification for the Dhall package:

```nix
# ./true.nix

{ buildDhallPackage, Prelude }:

buildDhallPackage {
  name = "true";
  code = ./true.dhall;
  dependencies = [ Prelude ];
  source = true;
}
```

… and we complete the build by incorporating that Dhall package into the
`pkgs.dhallPackages` hierarchy using an overlay, like this:

```nix
# ./example.nix

let
  nixpkgs = builtins.fetchTarball {
    url    = "https://github.com/NixOS/nixpkgs/archive/94b2848559b12a8ed1fe433084686b2a81123c99.tar.gz";
    hash = "sha256-B4Q3c6IvTLg3Q92qYa8y+i4uTaphtFdjp+Ir3QQjdN0=";
  };

  dhallOverlay = self: super: {
    true = self.callPackage ./true.nix { };
  };

  overlay = self: super: {
    dhallPackages = super.dhallPackages.override (old: {
      overrides =
        self.lib.composeExtensions (old.overrides or (_: _: {})) dhallOverlay;
    });
  };

  pkgs = import nixpkgs { config = {}; overlays = [ overlay ]; };

in
  pkgs
```

… which we can then build using this command:

```ShellSession
$ nix build --file ./example.nix dhallPackages.true
```

## Contents of a Dhall package {#ssec-dhall-package-contents}

The above package produces the following directory tree:

```ShellSession
$ tree -a ./result
result
├── .cache
│   └── dhall
│       └── 122027abdeddfe8503496adeb623466caa47da5f63abd2bc6fa19f6cfcb73ecfed70
├── binary.dhall
└── source.dhall
```

… where:

* `source.dhall` contains the result of interpreting our Dhall package:

  ```ShellSession
  $ cat ./result/source.dhall
  True
  ```

* The `.cache` subdirectory contains one binary cache product encoding the
  same result as `source.dhall`:

  ```ShellSession
  $ dhall decode < ./result/.cache/dhall/122027abdeddfe8503496adeb623466caa47da5f63abd2bc6fa19f6cfcb73ecfed70
  True
  ```

* `binary.dhall` contains a Dhall expression which handles fetching and decoding
  the same cache product:

  ```ShellSession
  $ cat ./result/binary.dhall
  missing sha256:27abdeddfe8503496adeb623466caa47da5f63abd2bc6fa19f6cfcb73ecfed70
  $ cp -r ./result/.cache .cache

  $ chmod -R u+w .cache

  $ XDG_CACHE_HOME=.cache dhall --file ./result/binary.dhall
  True
  ```

The `source.dhall` file is only present for packages that specify
`source = true;`.  By default, Dhall packages omit the `source.dhall` in order
to conserve disk space when they are used exclusively as dependencies.  For
example, if we build the Prelude package it will only contain the binary
encoding of the expression:

```ShellSession
$ nix build --file ./example.nix dhallPackages.Prelude

$ tree -a result
result
├── .cache
│   └── dhall
│       └── 122026b0ef498663d269e4dc6a82b0ee289ec565d683ef4c00d0ebdd25333a5a3c98
└── binary.dhall

2 directories, 2 files
```

Typically, you only specify `source = true;` for the top-level Dhall expression
of interest (such as our example `true.nix` Dhall package).  However, if you
wish to specify `source = true` for all Dhall packages, then you can amend the
Dhall overlay like this:

```nix
  dhallOverrides = self: super: {
    # Enable source for all Dhall packages
    buildDhallPackage =
      args: super.buildDhallPackage (args // { source = true; });

    true = self.callPackage ./true.nix { };
  };
```

… and now the Prelude will contain the fully decoded result of interpreting
the Prelude:

```ShellSession
$ nix build --file ./example.nix dhallPackages.Prelude

$ tree -a result
result
├── .cache
│   └── dhall
│       └── 122026b0ef498663d269e4dc6a82b0ee289ec565d683ef4c00d0ebdd25333a5a3c98
├── binary.dhall
└── source.dhall

$ cat ./result/source.dhall
{ Bool =
  { and =
      \(_ : List Bool) ->
        List/fold Bool _ Bool (\(_ : Bool) -> \(_ : Bool) -> _@1 && _) True
  , build = \(_ : Type -> _ -> _@1 -> _@2) -> _ Bool True False
  , even =
      \(_ : List Bool) ->
        List/fold Bool _ Bool (\(_ : Bool) -> \(_ : Bool) -> _@1 == _) True
  , fold =
      \(_ : Bool) ->
…
```

## Packaging functions {#ssec-dhall-packaging-functions}

We already saw an example of using `buildDhallPackage` to create a Dhall
package from a single file, but most Dhall packages consist of more than one
file and there are two derived utilities that you may find more useful when
packaging multiple files:

* `buildDhallDirectoryPackage` - build a Dhall package from a local directory

* `buildDhallGitHubPackage` - build a Dhall package from a GitHub repository

The `buildDhallPackage` is the lowest-level function and accepts the following
arguments:

* `name`: The name of the derivation

* `dependencies`: Dhall dependencies to build and cache ahead of time

* `code`: The top-level expression to build for this package

  Note that the `code` field accepts an arbitrary Dhall expression.  You're
  not limited to just a file.

* `source`: Set to `true` to include the decoded result as `source.dhall` in the
  build product, at the expense of requiring more disk space

* `documentationRoot`: Set to the root directory of the package if you want
  `dhall-docs` to generate documentation underneath the `docs` subdirectory of
  the build product

The `buildDhallDirectoryPackage` is a higher-level function implemented in terms
of `buildDhallPackage` that accepts the following arguments:

* `name`: Same as `buildDhallPackage`

* `dependencies`: Same as `buildDhallPackage`

* `source`: Same as `buildDhallPackage`

* `src`: The directory containing Dhall code that you want to turn into a Dhall
  package

* `file`: The top-level file (`package.dhall` by default) that is the entrypoint
  to the rest of the package

* `document`: Set to `true` to generate documentation for the package

The `buildDhallGitHubPackage` is another higher-level function implemented in
terms of `buildDhallPackage` that accepts the following arguments:

* `name`: Same as `buildDhallPackage`

* `dependencies`: Same as `buildDhallPackage`

* `source`: Same as `buildDhallPackage`

* `owner`: The owner of the repository

* `repo`: The repository name

* `rev`: The desired revision (or branch, or tag)

* `directory`: The subdirectory of the Git repository to package (if a
  directory other than the root of the repository)

* `file`: The top-level file (`${directory}/package.dhall` by default) that is
  the entrypoint to the rest of the package

* `document`: Set to `true` to generate documentation for the package

Additionally, `buildDhallGitHubPackage` accepts the same arguments as
`fetchFromGitHub`, such as `hash` or `fetchSubmodules`.

## `dhall-to-nixpkgs` {#ssec-dhall-dhall-to-nixpkgs}

You can use the `dhall-to-nixpkgs` command-line utility to automate
packaging Dhall code.  For example:

```ShellSession
$ nix-shell -p haskellPackages.dhall-nixpkgs nix-prefetch-git
[nix-shell]$ dhall-to-nixpkgs github https://github.com/Gabriella439/dhall-semver.git
{ buildDhallGitHubPackage, Prelude }:
  buildDhallGitHubPackage {
    name = "dhall-semver";
    githubBase = "github.com";
    owner = "Gabriella439";
    repo = "dhall-semver";
    rev = "2d44ae605302ce5dc6c657a1216887fbb96392a4";
    fetchSubmodules = false;
    hash = "sha256-n0nQtswVapWi/x7or0O3MEYmAkt/a1uvlOtnje6GGnk=";
    directory = "";
    file = "package.dhall";
    source = false;
    document = false;
    dependencies = [ (Prelude.overridePackage { file = "package.dhall"; }) ];
    }
```

:::{.note}
`nix-prefetch-git` has to be in `$PATH` for `dhall-to-nixpkgs` to work.
:::

The utility takes care of automatically detecting remote imports and converting
them to package dependencies.  You can also use the utility on local
Dhall directories, too:

```ShellSession
$ dhall-to-nixpkgs directory ~/proj/dhall-semver
{ buildDhallDirectoryPackage, Prelude }:
  buildDhallDirectoryPackage {
    name = "proj";
    src = ~/proj/dhall-semver;
    file = "package.dhall";
    source = false;
    document = false;
    dependencies = [ (Prelude.overridePackage { file = "package.dhall"; }) ];
    }
```

### Remote imports as fixed-output derivations {#ssec-dhall-remote-imports-as-fod}

`dhall-to-nixpkgs` has the ability to fetch and build remote imports as
fixed-output derivations by using their Dhall integrity check. This is
sometimes easier than manually packaging all remote imports.

This can be used like the following:

```ShellSession
$ dhall-to-nixpkgs directory --fixed-output-derivations ~/proj/dhall-semver
{ buildDhallDirectoryPackage, buildDhallUrl }:
  buildDhallDirectoryPackage {
    name = "proj";
    src = ~/proj/dhall-semver;
    file = "package.dhall";
    source = false;
    document = false;
    dependencies = [
      (buildDhallUrl {
        url = "https://prelude.dhall-lang.org/v17.0.0/package.dhall";
        hash = "sha256-ENs8kZwl6QRoM9+Jeo/+JwHcOQ+giT2VjDQwUkvlpD4=";
        dhallHash = "sha256:10db3c919c25e9046833df897a8ffe2701dc390fa0893d958c3430524be5a43e";
        })
      ];
    }
```

Here, `dhall-semver`'s `Prelude` dependency is fetched and built with the
`buildDhallUrl` helper function, instead of being passed in as a function
argument.

## Overriding dependency versions {#ssec-dhall-overriding-dependency-versions}

Suppose that we change our `true.dhall` example expression to depend on an older
version of the Prelude (19.0.0):

```dhall
-- ./true.dhall

let Prelude =
      https://prelude.dhall-lang.org/v19.0.0/package.dhall
        sha256:eb693342eb769f782174157eba9b5924cf8ac6793897fc36a31ccbd6f56dafe2

in  Prelude.Bool.not False
```

If we try to rebuild that expression the build will fail:

```ShellSession
$ nix build --file ./example.nix dhallPackages.true
builder for '/nix/store/0f1hla7ff1wiaqyk1r2ky4wnhnw114fi-true.drv' failed with exit code 1; last 10 log lines:

  Dhall was compiled without the 'with-http' flag.

  The requested URL was: https://prelude.dhall-lang.org/v19.0.0/package.dhall


  4│       https://prelude.dhall-lang.org/v19.0.0/package.dhall
  5│         sha256:eb693342eb769f782174157eba9b5924cf8ac6793897fc36a31ccbd6f56dafe2

  /nix/store/rsab4y99h14912h4zplqx2iizr5n4rc2-true.dhall:4:7
[1 built (1 failed), 0.0 MiB DL]
error: build of '/nix/store/0f1hla7ff1wiaqyk1r2ky4wnhnw114fi-true.drv' failed
```

… because the default Prelude selected by Nixpkgs revision
`94b2848559b12a8ed1fe433084686b2a81123c99is` is version 20.1.0, which doesn't
have the same integrity check as version 19.0.0.  This means that version
19.0.0 is not cached and the interpreter is not allowed to fall back to
importing the URL.

However, we can override the default Prelude version by using `dhall-to-nixpkgs`
to create a Dhall package for our desired Prelude:

```ShellSession
$ dhall-to-nixpkgs github https://github.com/dhall-lang/dhall-lang.git \
    --name Prelude \
    --directory Prelude \
    --rev v19.0.0 \
    > Prelude.nix
```

… and then referencing that package in our Dhall overlay, by either overriding
the Prelude globally for all packages, like this:

```nix
  dhallOverrides = self: super: {
    true = self.callPackage ./true.nix { };

    Prelude = self.callPackage ./Prelude.nix { };
  };
```

… or selectively overriding the Prelude dependency for just the `true` package,
like this:

```nix
  dhallOverrides = self: super: {
    true = self.callPackage ./true.nix {
      Prelude = self.callPackage ./Prelude.nix { };
    };
  };
```

## Overrides {#ssec-dhall-overrides}

You can override any of the arguments to `buildDhallGitHubPackage` or
`buildDhallDirectoryPackage` using the `overridePackage` attribute of a package.
For example, suppose we wanted to selectively enable `source = true` just for the Prelude.  We can do that like this:

```nix
  dhallOverrides = self: super: {
    Prelude = super.Prelude.overridePackage { source = true; };

    …
  };
```

[semantic-integrity-checks]: https://docs.dhall-lang.org/tutorials/Language-Tour.html#installing-packages
