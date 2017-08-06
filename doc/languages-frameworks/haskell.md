---
title: User's Guide for Haskell in Nixpkgs
author: Peter Simons
date: 2015-06-01
---
# User's Guide to the Haskell Infrastructure


## How to install Haskell packages

Nixpkgs distributes build instructions for all Haskell packages registered on
[Hackage](http://hackage.haskell.org/), but strangely enough normal Nix package
lookups don't seem to discover any of them, except for the default version of ghc, cabal-install, and stack:
```
$ nix-env -i alex
error: selector ‘alex’ matches no derivations
$ nix-env -qa ghc
ghc-7.10.2
```

The Haskell package set is not registered in the top-level namespace because it
is *huge*. If all Haskell packages were visible to these commands, then
name-based search/install operations would be much slower than they are now. We
avoided that by keeping all Haskell-related packages in a separate attribute
set called `haskellPackages`, which the following command will list:
```
$ nix-env -f "<nixpkgs>" -qaP -A haskellPackages
haskellPackages.a50         a50-0.5
haskellPackages.abacate     haskell-abacate-0.0.0.0
haskellPackages.abcBridge   haskell-abcBridge-0.12
haskellPackages.afv         afv-0.1.1
haskellPackages.alex        alex-3.1.4
haskellPackages.Allure      Allure-0.4.101.1
haskellPackages.alms        alms-0.6.7
[... some 8000 entries omitted  ...]
```

To install any of those packages into your profile, refer to them by their
attribute path (first column):
```shell
nix-env -f "<nixpkgs>" -iA haskellPackages.Allure ...
```

The attribute path of any Haskell packages corresponds to the name of that
particular package on Hackage: the package `cabal-install` has the attribute
`haskellPackages.cabal-install`, and so on. (Actually, this convention causes
trouble with packages like `3dmodels` and `4Blocks`, because these names are
invalid identifiers in the Nix language. The issue of how to deal with these
rare corner cases is currently unresolved.)

Haskell packages who's Nix name (second column) begins with a `haskell-` prefix
are packages that provide a library whereas packages without that prefix
provide just executables. Libraries may provide executables too, though: the
package `haskell-pandoc`, for example, installs both a library and an
application. You can install and use Haskell executables just like any other
program in Nixpkgs, but using Haskell libraries for development is a bit
trickier and we'll address that subject in great detail in section [How to
create a development environment].

Attribute paths are deterministic inside of Nixpkgs, but the path necessary to
reach Nixpkgs varies from system to system. We dodged that problem by giving
`nix-env` an explicit `-f "<nixpkgs>"` parameter, but if you call `nix-env`
without that flag, then chances are the invocation fails:
```
$ nix-env -iA haskellPackages.cabal-install
error: attribute ‘haskellPackages’ in selection path
       ‘haskellPackages.cabal-install’ not found
```

On NixOS, for example, Nixpkgs does *not* exist in the top-level namespace by
default. To figure out the proper attribute path, it's easiest to query for the
path of a well-known Nixpkgs package, i.e.:
```
$ nix-env -qaP coreutils
nixos.coreutils  coreutils-8.23
```

If your system responds like that (most NixOS installations will), then the
attribute path to `haskellPackages` is `nixos.haskellPackages`. Thus, if you
want to use `nix-env` without giving an explicit `-f` flag, then that's the way
to do it:
```shell
nix-env -qaP -A nixos.haskellPackages
nix-env -iA nixos.haskellPackages.cabal-install
```

Our current default compiler is GHC 7.10.x and the `haskellPackages` set
contains packages built with that particular version. Nixpkgs contains the
latest major release of every GHC since 6.10.4, however, and there is a whole
family of package sets available that defines Hackage packages built with each
of those compilers, too:
```shell
nix-env -f "<nixpkgs>" -qaP -A haskell.packages.ghc6123
nix-env -f "<nixpkgs>" -qaP -A haskell.packages.ghc763
```

The name `haskellPackages` is really just a synonym for
`haskell.packages.ghc7102`, because we prefer that package set internally and
recommend it to our users as their default choice, but ultimately you are free
to compile your Haskell packages with any GHC version you please. The following
command displays the complete list of available compilers:
```
$ nix-env -f "<nixpkgs>" -qaP -A haskell.compiler
haskell.compiler.ghc6104        ghc-6.10.4
haskell.compiler.ghc6123        ghc-6.12.3
haskell.compiler.ghc704         ghc-7.0.4
haskell.compiler.ghc722         ghc-7.2.2
haskell.compiler.ghc742         ghc-7.4.2
haskell.compiler.ghc763         ghc-7.6.3
haskell.compiler.ghc784         ghc-7.8.4
haskell.compiler.ghc7102        ghc-7.10.2
haskell.compiler.ghcHEAD        ghc-7.11.20150402
haskell.compiler.ghcNokinds     ghc-nokinds-7.11.20150704
haskell.compiler.ghcjs          ghcjs-0.1.0
haskell.compiler.jhc            jhc-0.8.2
haskell.compiler.uhc            uhc-1.1.9.0
```

We have no package sets for `jhc` or `uhc` yet, unfortunately, but for every
version of GHC listed above, there exists a package set based on that compiler.
Also, the attributes `haskell.compiler.ghcXYC` and
`haskell.packages.ghcXYC.ghc` are synonymous for the sake of convenience.

## How to create a development environment

### How to install a compiler

A simple development environment consists of a Haskell compiler and one or both
of the tools `cabal-install` and `stack`. We saw in section
[How to install Haskell packages] how you can install those programs into your
user profile:
```shell
nix-env -f "<nixpkgs>" -iA haskellPackages.ghc haskellPackages.cabal-install
```

Instead of the default package set `haskellPackages`, you can also use the more
precise name `haskell.compiler.ghc7102`, which has the advantage that it refers
to the same GHC version regardless of what Nixpkgs considers "default" at any
given time.

Once you've made those tools available in `$PATH`, it's possible to build
Hackage packages the same way people without access to Nix do it all the time:
```shell
cabal get lens-4.11 && cd lens-4.11
cabal install -j --dependencies-only
cabal configure
cabal build
```

If you enjoy working with Cabal sandboxes, then that's entirely possible too:
just execute the command
```shell
cabal sandbox init
```
before installing the required dependencies.

The `nix-shell` utility makes it easy to switch to a different compiler
version; just enter the Nix shell environment with the command
```shell
nix-shell -p haskell.compiler.ghc784
```
to bring GHC 7.8.4 into `$PATH`. Alternatively, you can use Stack instead of
`nix-shell` directly to select compiler versions and other build tools
per-project. It uses `nix-shell` under the hood when Nix support is turned on.
See [How to build a Haskell project using Stack].

If you're using `cabal-install`, re-running `cabal configure` inside the spawned
shell switches your build to use that compiler instead. If you're working on
a project that doesn't depend on any additional system libraries outside of GHC,
then it's even sufficient to just run the `cabal configure` command inside of
the shell:
```shell
nix-shell -p haskell.compiler.ghc784 --command "cabal configure"
```

Afterwards, all other commands like `cabal build` work just fine in any shell
environment, because the configure phase recorded the absolute paths to all
required tools like GHC in its build configuration inside of the `dist/`
directory. Please note, however, that `nix-collect-garbage` can break such an
environment because the Nix store paths created by `nix-shell` aren't "alive"
anymore once `nix-shell` has terminated. If you find that your Haskell builds
no longer work after garbage collection, then you'll have to re-run `cabal
configure` inside of a new `nix-shell` environment.

### How to install a compiler with libraries

GHC expects to find all installed libraries inside of its own `lib` directory.
This approach works fine on traditional Unix systems, but it doesn't work for
Nix, because GHC's store path is immutable once it's built. We cannot install
additional libraries into that location. As a consequence, our copies of GHC
don't know any packages except their own core libraries, like `base`,
`containers`, `Cabal`, etc.

We can register additional libraries to GHC, however, using a special build
function called `ghcWithPackages`. That function expects one argument: a
function that maps from an attribute set of Haskell packages to a list of
packages, which determines the libraries known to that particular version of
GHC. For example, the Nix expression `ghcWithPackages (pkgs: [pkgs.mtl])`
generates a copy of GHC that has the `mtl` library registered in addition to
its normal core packages:
```
$ nix-shell -p "haskellPackages.ghcWithPackages (pkgs: [pkgs.mtl])"

[nix-shell:~]$ ghc-pkg list mtl
/nix/store/zy79...-ghc-7.10.2/lib/ghc-7.10.2/package.conf.d:
    mtl-2.2.1
```

This function allows users to define their own development environment by means
of an override. After adding the following snippet to `~/.config/nixpkgs/config.nix`,
```nix
{
  packageOverrides = super: let self = super.pkgs; in
  {
    myHaskellEnv = self.haskell.packages.ghc7102.ghcWithPackages
                     (haskellPackages: with haskellPackages; [
                       # libraries
                       arrows async cgi criterion
                       # tools
                       cabal-install haskintex
                     ]);
  };
}
```
it's possible to install that compiler with `nix-env -f "<nixpkgs>" -iA
myHaskellEnv`. If you'd like to switch that development environment to a
different version of GHC, just replace the `ghc7102` bit in the previous
definition with the appropriate name. Of course, it's also possible to define
any number of these development environments! (You can't install two of them
into the same profile at the same time, though, because that would result in
file conflicts.)

The generated `ghc` program is a wrapper script that re-directs the real
GHC executable to use a new `lib` directory --- one that we specifically
constructed to contain all those packages the user requested:
```
$ cat $(type -p ghc)
#! /nix/store/xlxj...-bash-4.3-p33/bin/bash -e
export NIX_GHC=/nix/store/19sm...-ghc-7.10.2/bin/ghc
export NIX_GHCPKG=/nix/store/19sm...-ghc-7.10.2/bin/ghc-pkg
export NIX_GHC_DOCDIR=/nix/store/19sm...-ghc-7.10.2/share/doc/ghc/html
export NIX_GHC_LIBDIR=/nix/store/19sm...-ghc-7.10.2/lib/ghc-7.10.2
exec /nix/store/j50p...-ghc-7.10.2/bin/ghc "-B$NIX_GHC_LIBDIR" "$@"
```

The variables `$NIX_GHC`, `$NIX_GHCPKG`, etc. point to the *new* store path
`ghcWithPackages` constructed specifically for this environment. The last line
of the wrapper script then executes the real `ghc`, but passes the path to the
new `lib` directory using GHC's `-B` flag.

The purpose of those environment variables is to work around an impurity in the
popular [ghc-paths](http://hackage.haskell.org/package/ghc-paths) library. That
library promises to give its users access to GHC's installation paths. Only,
the library can't possible know that path when it's compiled, because the path
GHC considers its own is determined only much later, when the user configures
it through `ghcWithPackages`. So we [patched
ghc-paths](https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/haskell-modules/patches/ghc-paths-nix.patch)
to return the paths found in those environment variables at run-time rather
than trying to guess them at compile-time.

To make sure that mechanism works properly all the time, we recommend that you
set those variables to meaningful values in your shell environment, too, i.e.
by adding the following code to your `~/.bashrc`:
```bash
if type >/dev/null 2>&1 -p ghc; then
  eval "$(egrep ^export "$(type -p ghc)")"
fi
```

If you are certain that you'll use only one GHC environment which is located in
your user profile, then you can use the following code, too, which has the
advantage that it doesn't contain any paths from the Nix store, i.e. those
settings always remain valid even if a `nix-env -u` operation updates the GHC
environment in your profile:
```bash
if [ -e ~/.nix-profile/bin/ghc ]; then
  export NIX_GHC="$HOME/.nix-profile/bin/ghc"
  export NIX_GHCPKG="$HOME/.nix-profile/bin/ghc-pkg"
  export NIX_GHC_DOCDIR="$HOME/.nix-profile/share/doc/ghc/html"
  export NIX_GHC_LIBDIR="$HOME/.nix-profile/lib/ghc-$($NIX_GHC --numeric-version)"
fi
```

### How to install a compiler with libraries, hoogle and documentation indexes

If you plan to use your environment for interactive programming, not just
compiling random Haskell code, you might want to replace `ghcWithPackages` in
all the listings above with `ghcWithHoogle`.

This environment generator not only produces an environment with GHC and all
the specified libraries, but also generates a `hoogle` and `haddock` indexes
for all the packages, and provides a wrapper script around `hoogle` binary that
uses all those things. A precise name for this thing would be
"`ghcWithPackagesAndHoogleAndDocumentationIndexes`", which is, regrettably, too
long and scary.

For example, installing the following environment
```nix
{
  packageOverrides = super: let self = super.pkgs; in
  {
    myHaskellEnv = self.haskellPackages.ghcWithHoogle
                     (haskellPackages: with haskellPackages; [
                       # libraries
                       arrows async cgi criterion
                       # tools
                       cabal-install haskintex
                     ]);
  };
}
```
allows one to browse module documentation index [not too dissimilar to
this](https://downloads.haskell.org/~ghc/latest/docs/html/libraries/index.html)
for all the specified packages and their dependencies by directing a browser of
choice to `~/.nix-profiles/share/doc/hoogle/index.html` (or
`/run/current-system/sw/share/doc/hoogle/index.html` in case you put it in
`environment.systemPackages` in NixOS).

After you've marveled enough at that try adding the following to your
`~/.ghc/ghci.conf`
```
:def hoogle \s -> return $ ":! hoogle search -cl --count=15 \"" ++ s ++ "\""
:def doc \s -> return $ ":! hoogle search -cl --info \"" ++ s ++ "\""
```
and test it by typing into `ghci`:
```
:hoogle a -> a
:doc a -> a
```

Be sure to note the links to `haddock` files in the output. With any modern and
properly configured terminal emulator you can just click those links to
navigate there.

Finally, you can run
```shell
hoogle server -p 8080
```
and navigate to http://localhost:8080/ for your own local
[Hoogle](https://www.haskell.org/hoogle/). Note, however, that Firefox and
possibly other browsers disallow navigation from `http:` to `file:` URIs for
security reasons, which might be quite an inconvenience. See [this
page](http://kb.mozillazine.org/Links_to_local_pages_do_not_work) for
workarounds.

### How to build a Haskell project using Stack

[Stack](http://haskellstack.org) is a popular build tool for Haskell projects.
It has first-class support for Nix. Stack can optionally use Nix to
automatically select the right version of GHC and other build tools to build,
test and execute apps in an existing project downloaded from somewhere on the
Internet. Pass the `--nix` flag to any `stack` command to do so, e.g.
```shell
git clone --recursive http://github.com/yesodweb/wai
cd wai
stack --nix build
```

If you want `stack` to use Nix by default, you can add a `nix` section to the
`stack.yaml` file, as explained in the [Stack documentation][stack-nix-doc]. For
example:
```yaml
nix:
  enable: true
  packages: [pkgconfig zeromq zlib]
```

The example configuration snippet above tells Stack to create an ad hoc
environment for `nix-shell` as in the below section, in which the `pkgconfig`,
`zeromq` and `zlib` packages from Nixpkgs are available. All `stack` commands
will implicitly be executed inside this ad hoc environment.

Some projects have more sophisticated needs. For examples, some ad hoc
environments might need to expose Nixpkgs packages compiled in a certain way, or
with extra environment variables. In these cases, you'll need a `shell` field
instead of `packages`:
```yaml
nix:
  enable: true
  shell-file: shell.nix
```

For more on how to write a `shell.nix` file see the below section. You'll need
to express a derivation. Note that Nixpkgs ships with a convenience wrapper
function around `mkDerivation` called `haskell.lib.buildStackProject` to help you
create this derivation in exactly the way Stack expects. All of the same inputs
as `mkDerivation` can be provided. For example, to build a Stack project that
including packages that link against a version of the R library compiled with
special options turned on:
```nix
with (import <nixpkgs> { });

let R = pkgs.R.override { enableStrictBarrier = true; };
in
haskell.lib.buildStackProject {
  name = "HaskellR";
  buildInputs = [ R zeromq zlib ];
}
```

You can select a particular GHC version to compile with by setting the
`ghc` attribute as an argument to `buildStackProject`. Better yet, let
Stack choose what GHC version it wants based on the snapshot specified
in `stack.yaml` (only works with Stack >= 1.1.3):
```nix
{nixpkgs ? import <nixpkgs> { }, ghc ? nixpkgs.ghc}:

with nixpkgs;

let R = pkgs.R.override { enableStrictBarrier = true; };
in
haskell.lib.buildStackProject {
  name = "HaskellR";
  buildInputs = [ R zeromq zlib ];
  inherit ghc;
}
```

[stack-nix-doc]: http://docs.haskellstack.org/en/stable/nix_integration.html

### How to create ad hoc environments for `nix-shell`

The easiest way to create an ad hoc development environment is to run
`nix-shell` with the appropriate GHC environment given on the command-line:
```shell
nix-shell -p "haskellPackages.ghcWithPackages (pkgs: with pkgs; [mtl pandoc])"
```

For more sophisticated use-cases, however, it's more convenient to save the
desired configuration in a file called `shell.nix` that looks like this:
```nix
{ nixpkgs ? import <nixpkgs> {}, compiler ? "ghc7102" }:
let
  inherit (nixpkgs) pkgs;
  ghc = pkgs.haskell.packages.${compiler}.ghcWithPackages (ps: with ps; [
          monad-par mtl
        ]);
in
pkgs.stdenv.mkDerivation {
  name = "my-haskell-env-0";
  buildInputs = [ ghc ];
  shellHook = "eval $(egrep ^export ${ghc}/bin/ghc)";
}
```

Now run `nix-shell` --- or even `nix-shell --pure` --- to enter a shell
environment that has the appropriate compiler in `$PATH`. If you use `--pure`,
then add all other packages that your development environment needs into the
`buildInputs` attribute. If you'd like to switch to a different compiler
version, then pass an appropriate `compiler` argument to the expression, i.e.
`nix-shell --argstr compiler ghc784`.

If you need such an environment because you'd like to compile a Hackage package
outside of Nix --- i.e. because you're hacking on the latest version from Git
---, then the package set provides suitable nix-shell environments for you
already! Every Haskell package has an `env` attribute that provides a shell
environment suitable for compiling that particular package. If you'd like to
hack the `lens` library, for example, then you just have to check out the
source code and enter the appropriate environment:
```
$ cabal get lens-4.11 && cd lens-4.11
Downloading lens-4.11...
Unpacking to lens-4.11/

$ nix-shell "<nixpkgs>" -A haskellPackages.lens.env
[nix-shell:/tmp/lens-4.11]$
```

At point, you can run `cabal configure`, `cabal build`, and all the other
development commands. Note that you need `cabal-install` installed in your
`$PATH` already to use it here --- the `nix-shell` environment does not provide
it.

## How to create Nix builds for your own private Haskell packages

If your own Haskell packages have build instructions for Cabal, then you can
convert those automatically into build instructions for Nix using the
`cabal2nix` utility, which you can install into your profile by running
`nix-env -i cabal2nix`.

### How to build a stand-alone project

For example, let's assume that you're working on a private project called
`foo`. To generate a Nix build expression for it, change into the project's
top-level directory and run the command:
```shell
cabal2nix . > foo.nix
```
Then write the following snippet into a file called `default.nix`:
```nix
{ nixpkgs ? import <nixpkgs> {}, compiler ? "ghc7102" }:
nixpkgs.pkgs.haskell.packages.${compiler}.callPackage ./foo.nix { }
```

Finally, store the following code in a file called `shell.nix`:
```nix
{ nixpkgs ? import <nixpkgs> {}, compiler ? "ghc7102" }:
(import ./default.nix { inherit nixpkgs compiler; }).env
```

At this point, you can run `nix-build` to have Nix compile your project and
install it into a Nix store path. The local directory will contain a symlink
called `result` after `nix-build` returns that points into that location. Of
course, passing the flag `--argstr compiler ghc763` allows switching the build
to any version of GHC currently supported.

Furthermore, you can call `nix-shell` to enter an interactive development
environment in which you can use `cabal configure` and `cabal build` to develop
your code. That environment will automatically contain a proper GHC derivation
with all the required libraries registered as well as all the system-level
libraries your package might need.

If your package does not depend on any system-level libraries, then it's
sufficient to run
```shell
nix-shell --command "cabal configure"
```
once to set up your build. `cabal-install` determines the absolute paths to all
resources required for the build and writes them into a config file in the
`dist/` directory. Once that's done, you can run `cabal build` and any other
command for that project even outside of the `nix-shell` environment. This
feature is particularly nice for those of us who like to edit their code with
an IDE, like Emacs' `haskell-mode`, because it's not necessary to start Emacs
inside of nix-shell just to make it find out the necessary settings for
building the project; `cabal-install` has already done that for us.

If you want to do some quick-and-dirty hacking and don't want to bother setting
up a `default.nix` and `shell.nix` file manually, then you can use the
`--shell` flag offered by `cabal2nix` to have it generate a stand-alone
`nix-shell` environment for you. With that feature, running
```shell
cabal2nix --shell . > shell.nix
nix-shell --command "cabal configure"
```
is usually enough to set up a build environment for any given Haskell package.
You can even use that generated file to run `nix-build`, too:
```shell
nix-build shell.nix
```

### How to build projects that depend on each other

If you have multiple private Haskell packages that depend on each other, then
you'll have to register those packages in the Nixpkgs set to make them visible
for the dependency resolution performed by `callPackage`. First of all, change
into each of your projects top-level directories and generate a `default.nix`
file with `cabal2nix`:
```shell
cd ~/src/foo && cabal2nix . > default.nix
cd ~/src/bar && cabal2nix . > default.nix
```
Then edit your `~/.config/nixpkgs/config.nix` file to register those builds in the
default Haskell package set:
```nix
{
  packageOverrides = super: let self = super.pkgs; in
  {
    haskellPackages = super.haskellPackages.override {
      overrides = self: super: {
        foo = self.callPackage ../src/foo {};
        bar = self.callPackage ../src/bar {};
      };
    };
  };
}
```
Once that's accomplished, `nix-env -f "<nixpkgs>" -qA haskellPackages` will
show your packages like any other package from Hackage, and you can build them
```shell
nix-build "<nixpkgs>" -A haskellPackages.foo
```
or enter an interactive shell environment suitable for building them:
```shell
nix-shell "<nixpkgs>" -A haskellPackages.bar.env
```

## Miscellaneous Topics

### How to build with profiling enabled

Every Haskell package set takes a function called `overrides` that you can use
to manipulate the package as much as you please. One useful application of this
feature is to replace the default `mkDerivation` function with one that enables
library profiling for all packages. To accomplish that, add configure the
following snippet in your `~/.config/nixpkgs/config.nix` file:
```nix
{
  packageOverrides = super: let self = super.pkgs; in
  {
    profiledHaskellPackages = self.haskellPackages.override {
      overrides = self: super: {
        mkDerivation = args: super.mkDerivation (args // {
          enableLibraryProfiling = true;
        });
      };
    };
  };
}
```
Then, replace instances of `haskellPackages` in the `cabal2nix`-generated
`default.nix` or `shell.nix` files with `profiledHaskellPackages`.

### How to override package versions in a compiler-specific package set

Nixpkgs provides the latest version of
[`ghc-events`](http://hackage.haskell.org/package/ghc-events), which is 0.4.4.0
at the time of this writing. This is fine for users of GHC 7.10.x, but GHC
7.8.4 cannot compile that binary. Now, one way to solve that problem is to
register an older version of `ghc-events` in the 7.8.x-specific package set.
The first step is to generate Nix build instructions with `cabal2nix`:
```shell
cabal2nix cabal://ghc-events-0.4.3.0 > ~/.nixpkgs/ghc-events-0.4.3.0.nix
```
Then add the override in `~/.config/nixpkgs/config.nix`:
```nix
{
  packageOverrides = super: let self = super.pkgs; in
  {
    haskell = super.haskell // {
      packages = super.haskell.packages // {
        ghc784 = super.haskell.packages.ghc784.override {
          overrides = self: super: {
            ghc-events = self.callPackage ./ghc-events-0.4.3.0.nix {};
          };
        };
      };
    };
  };
}
```

This code is a little crazy, no doubt, but it's necessary because the intuitive
version
```nix
{ # ...

  haskell.packages.ghc784 = super.haskell.packages.ghc784.override {
    overrides = self: super: {
      ghc-events = self.callPackage ./ghc-events-0.4.3.0.nix {};
    };
  };
}
```
doesn't do what we want it to: that code replaces the `haskell` package set in
Nixpkgs with one that contains only one entry,`packages`, which contains only
one entry `ghc784`. This override loses the `haskell.compiler` set, and it
loses the `haskell.packages.ghcXYZ` sets for all compilers but GHC 7.8.4. To
avoid that problem, we have to perform the convoluted little dance from above,
iterating over each step in hierarchy.

Once it's accomplished, however, we can install a variant of `ghc-events`
that's compiled with GHC 7.8.4:
```shell
nix-env -f "<nixpkgs>" -iA haskell.packages.ghc784.ghc-events
```
Unfortunately, it turns out that this build fails again while executing the
test suite! Apparently, the release archive on Hackage is missing some data
files that the test suite requires, so we cannot run it. We accomplish that by
re-generating the Nix expression with the `--no-check` flag:
```shell
cabal2nix --no-check cabal://ghc-events-0.4.3.0 > ~/.nixpkgs/ghc-events-0.4.3.0.nix
```
Now the builds succeeds.

Of course, in the concrete example of `ghc-events` this whole exercise is not
an ideal solution, because `ghc-events` can analyze the output emitted by any
version of GHC later than 6.12 regardless of the compiler version that was used
to build the `ghc-events` executable, so strictly speaking there's no reason to
prefer one built with GHC 7.8.x in the first place. However, for users who
cannot use GHC 7.10.x at all for some reason, the approach of downgrading to an
older version might be useful.

### How to recover from GHC's infamous non-deterministic library ID bug

GHC and distributed build farms don't get along well:

  - https://ghc.haskell.org/trac/ghc/ticket/4012

When you see an error like this one
```
package foo-0.7.1.0 is broken due to missing package
text-1.2.0.4-98506efb1b9ada233bb5c2b2db516d91
```
then you have to download and re-install `foo` and all its dependents from
scratch:
```shell
nix-store -q --referrers /nix/store/*-haskell-text-1.2.0.4 \
  | xargs -L 1 nix-store --repair-path
```

If you're using additional Hydra servers other than `hydra.nixos.org`, then it
might be necessary to purge the local caches that store data from those
machines to disable these binary channels for the duration of the previous
command, i.e. by running:
```shell
rm /nix/var/nix/binary-cache-v3.sqlite
rm /nix/var/nix/manifests/*
rm /nix/var/nix/channel-cache/*
```

### Builds on Darwin fail with `math.h` not found

Users of GHC on Darwin have occasionally reported that builds fail, because the
compiler complains about a missing include file:
```
fatal error: 'math.h' file not found
```
The issue has been discussed at length in [ticket
6390](https://github.com/NixOS/nixpkgs/issues/6390), and so far no good
solution has been proposed. As a work-around, users who run into this problem
can configure the environment variables
```shell
export NIX_CFLAGS_COMPILE="-idirafter /usr/include"
export NIX_CFLAGS_LINK="-L/usr/lib"
```
in their `~/.bashrc` file to avoid the compiler error.

### Builds using Stack complain about missing system libraries

```
--  While building package zlib-0.5.4.2 using:
  runhaskell -package=Cabal-1.22.4.0 -clear-package-db [... lots of flags ...]
Process exited with code: ExitFailure 1
Logs have been written to: /home/foo/src/stack-ide/.stack-work/logs/zlib-0.5.4.2.log

Configuring zlib-0.5.4.2...
Setup.hs: Missing dependency on a foreign library:
* Missing (or bad) header file: zlib.h
This problem can usually be solved by installing the system package that
provides this library (you may need the "-dev" version). If the library is
already installed but in a non-standard location then you can use the flags
--extra-include-dirs= and --extra-lib-dirs= to specify where it is.
If the header file does exist, it may contain errors that are caught by the C
compiler at the preprocessing stage. In this case you can re-run configure
with the verbosity flag -v3 to see the error messages.
```

When you run the build inside of the nix-shell environment, the system
is configured to find `libz.so` without any special flags -- the compiler
and linker "just know" how to find it. Consequently, Cabal won't record
any search paths for `libz.so` in the package description, which means
that the package works fine inside of nix-shell, but once you leave the
shell the shared object can no longer be found. That issue is by no
means specific to Stack: you'll have that problem with any other
Haskell package that's built inside of nix-shell but run outside of that
environment.

You can remedy this issue in several ways. The easiest is to add a `nix` section
to the `stack.yaml` like the following:
```yaml
nix:
  enable: true
  packages: [ zlib ]
```

Stack's Nix support knows to add `${zlib.out}/lib` and `${zlib.dev}/include`
as an `--extra-lib-dirs` and `extra-include-dirs`, respectively.
Alternatively, you can achieve the same effect by hand. First of all, run
```
$ nix-build --no-out-link "<nixpkgs>" -A zlib
/nix/store/alsvwzkiw4b7ip38l4nlfjijdvg3fvzn-zlib-1.2.8
```
to find out the store path of the system's zlib library. Now, you can

  1. add that path (plus a "/lib" suffix) to your `$LD_LIBRARY_PATH`
    environment variable to make sure your system linker finds `libz.so`
    automatically. It's no pretty solution, but it will work.

  2. As a variant of (1), you can also install any number of system
    libraries into your user's profile (or some other profile) and point
    `$LD_LIBRARY_PATH` to that profile instead, so that you don't have to
    list dozens of those store paths all over the place.

  3. The solution I prefer is to call stack with an appropriate
    --extra-lib-dirs flag like so:
    ```shell
    stack --extra-lib-dirs=/nix/store/alsvwzkiw4b7ip38l4nlfjijdvg3fvzn-zlib-1.2.8/lib build
    ```

    Typically, you'll need `--extra-include-dirs` as well. It's possible
    to add those flag to the project's `stack.yaml` or your user's
    global `~/.stack/global/stack.yaml` file so that you don't have to
    specify them manually every time. But again, you're likely better off
    using Stack's Nix support instead.

    The same thing applies to `cabal configure`, of course, if you're
    building with `cabal-install` instead of Stack.

### Creating statically linked binaries

There are two levels of static linking. The first option is to configure the
build with the Cabal flag `--disable-executable-dynamic`. In Nix expressions,
this can be achieved by setting the attribute:
```
enableSharedExecutables = false;
```
That gives you a binary with statically linked Haskell libraries and
dynamically linked system libraries.

To link both Haskell libraries and system libraries statically, the additional
flags `--ghc-option=-optl=-static --ghc-option=-optl=-pthread` need to be used.
In Nix, this is accomplished with:
```
configureFlags = [ "--ghc-option=-optl=-static" "--ghc-option=-optl=-pthread" ];
```

It's important to realize, however, that most system libraries in Nix are
built as shared libraries only, i.e. there is just no static library
available that Cabal could link!

### Building GHC with integer-simple

By default GHC implements the Integer type using the
[GNU Multiple Precision Arithmetic (GMP) library](https://gmplib.org/).
The implementation can be found in the
[integer-gmp](http://hackage.haskell.org/package/integer-gmp) package.

A potential problem with this is that GMP is licensed under the
[GNU Lesser General Public License (LGPL)](http://www.gnu.org/copyleft/lesser.html),
a kind of "copyleft" license. According to the terms of the LGPL, paragraph 5,
you may distribute a program that is designed to be compiled and dynamically
linked with the library under the terms of your choice (i.e., commercially) but
if your program incorporates portions of the library, if it is linked
statically, then your program is a "derivative"--a "work based on the
library"--and according to paragraph 2, section c, you "must cause the whole of
the work to be licensed" under the terms of the LGPL (including for free).

The LGPL licensing for GMP is a problem for the overall licensing of binary
programs compiled with GHC because most distributions (and builds) of GHC use
static libraries. (Dynamic libraries are currently distributed only for macOS.)
The LGPL licensing situation may be worse: even though
[The Glasgow Haskell Compiler License](https://www.haskell.org/ghc/license)
is essentially a "free software" license (BSD3), according to
paragraph 2 of the LGPL, GHC must be distributed under the terms of the LGPL!

To work around these problems GHC can be build with a slower but LGPL-free
alternative implemention for Integer called
[integer-simple](http://hackage.haskell.org/package/integer-simple).

To get a GHC compiler build with `integer-simple` instead of `integer-gmp` use
the attribute: `haskell.compiler.integer-simple."${ghcVersion}"`.
For example:
```
$ nix-build -E '(import <nixpkgs> {}).haskell.compiler.integer-simple.ghc802'
...
$ result/bin/ghc-pkg list | grep integer
    integer-simple-0.1.1.1
```
The following command displays the complete list of GHC compilers build with `integer-simple`:
```
$ nix-env -f "<nixpkgs>" -qaP -A haskell.compiler.integer-simple
haskell.compiler.integer-simple.ghc7102  ghc-7.10.2
haskell.compiler.integer-simple.ghc7103  ghc-7.10.3
haskell.compiler.integer-simple.ghc722   ghc-7.2.2
haskell.compiler.integer-simple.ghc742   ghc-7.4.2
haskell.compiler.integer-simple.ghc783   ghc-7.8.3
haskell.compiler.integer-simple.ghc784   ghc-7.8.4
haskell.compiler.integer-simple.ghc801   ghc-8.0.1
haskell.compiler.integer-simple.ghc802   ghc-8.0.2
haskell.compiler.integer-simple.ghcHEAD  ghc-8.1.20170106
```

To get a package set supporting `integer-simple` use the attribute:
`haskell.packages.integer-simple."${ghcVersion}"`. For example
use the following to get the `scientific` package build with `integer-simple`:
```shell
nix-build -A haskell.packages.integer-simple.ghc802.scientific
```

## Other resources

  - The Youtube video [Nix Loves Haskell](https://www.youtube.com/watch?v=BsBhi_r-OeE)
    provides an introduction into Haskell NG aimed at beginners. The slides are
    available at http://cryp.to/nixos-meetup-3-slides.pdf and also -- in a form
    ready for cut & paste -- at
    https://github.com/NixOS/cabal2nix/blob/master/doc/nixos-meetup-3-slides.md.

  - Another Youtube video is [Escaping Cabal Hell with Nix](https://www.youtube.com/watch?v=mQd3s57n_2Y),
    which discusses the subject of Haskell development with Nix but also provides
    a basic introduction to Nix as well, i.e. it's suitable for viewers with
    almost no prior Nix experience.

  - Oliver Charles wrote a very nice [Tutorial how to develop Haskell packages with Nix](http://wiki.ocharles.org.uk/Nix).

  - The *Journey into the Haskell NG infrastructure* series of postings
    describe the new Haskell infrastructure in great detail:

      - [Part 1](https://nixos.org/nix-dev/2015-January/015591.html)
        explains the differences between the old and the new code and gives
        instructions how to migrate to the new setup.

      - [Part 2](https://nixos.org/nix-dev/2015-January/015608.html)
        looks in-depth at how to tweak and configure your setup by means of
        overrides.

      - [Part 3](https://nixos.org/nix-dev/2015-April/016912.html)
        describes the infrastructure that keeps the Haskell package set in Nixpkgs
        up-to-date.
