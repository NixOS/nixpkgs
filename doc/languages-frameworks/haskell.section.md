# Haskell {#sec-haskell}

The Haskell infrastructure in nixpkgs has two main purposes: The primary purpose
is to provide a Haskell compiler and build tools as well as infrastructure for
packaging Haskell-based packages.

The secondary purpose is to provide support for Haskell development environment
including prebuilt Haskell libraries. However, in this area sacrifices have been
made due to self-imposed restrictions in nixpkgs, to lessen the maintenance
effort and improve performance. Therefore, it may be advantageous to use an
alternative to the Haskell infrastructure in nixpkgs for development
environments in some cases. The main limitations are that we only provide
first-class support for the default compiler (currently GHC 9.2.4) and usually
only provide a default and (if different) the latest version of a haskell
package.

<!-- TODO(@sternensemann): Fix duplication w.r.t. package set generations
and package set rationale from a maintenance perspective. Probably just add
a dedicated section for this…
-->

## Available packages {#sec-haskell-available-packages}

The compiler and most build tools are exposed at the top level:

* `ghc` is the default version of GHC
* Language specific tools: `cabal-install`, `stack`, `hpack`, …

Many “normal” user facing packages written in Haskell, like `niv` or `cachix`,
are also exposed at the top level, so there is nothing haskell specific to
installing and using them.

All of these packages originally lived in the `haskellPackages` package set and
are re-exposed with a reduced dependency closure for convenience.

The `haskellPackages` set includes at least one version of every package from
hackage as well as some manually injected packages. This amounts to a lot of
packages, so it is hidden from `nix-env -qa` by default for performance reasons.
You can still list all packages in the set like this, though:

```console
$ nix-env -f '<nixpkgs>' -qaP -A haskellPackages
haskellPackages.a50                                                         a50-0.5
haskellPackages.AAI                                                         AAI-0.2.0.1
haskellPackages.aasam                                                       aasam-0.2.0.0
haskellPackages.abacate                                                     abacate-0.0.0.0
haskellPackages.abc-puzzle                                                  abc-puzzle-0.2.1
…
```

The attribute names in `haskellPackages` always correspond with their name on
hackage. Since hackage allows names that are not valid nix without extra
escaping, you sometimes need to extra care when handling attribute names like
`3dmodels`.

For packages that are part of [Stackage], we use the version prescribed by a
Stackage solver (usually the current LTS one) as the default version. For all
other packages we use the latest version from Hackage. Sometimes alternative
versions of packages are provided whose attribute names are their normal name
with their version appended after an underscore, e.g. `Cabal_3_8_1_0`.

<!--
TODO(@sternenseemann):
If you are interested in details how the package set is
populated, read the section [Package set
generation](#sec-haskell-package-set-generation).
-->

Roughly half of the 16K packages contained in `haskellPackages` don't actually
build and are marked as broken semi-automatically. Most of those packages are
deprecated or unmaintained, but sometimes packages that should, don't build.
Very often fixing them is not a lot of work.

<!--
TODO(@sternenseemann):
How you can help with that is
described in [Fixing a broken package](#sec-haskell-fixing-a-broken-package).
-->

`haskellPackages` is built with our default compiler, but we also provide other
releases of GHC and package sets built with them. You can list all available
compilers like this:

```console
$ nix-env -f '<nixpkgs>' -qaP -A haskell.compiler
haskell.compiler.ghc810                  ghc-8.10.7
haskell.compiler.ghc88                   ghc-8.8.4
haskell.compiler.ghc90                   ghc-9.0.2
haskell.compiler.ghc92                   ghc-9.2.4
haskell.compiler.ghc925                  ghc-9.2.5
haskell.compiler.ghc942                  ghc-9.4.2
haskell.compiler.ghc943                  ghc-9.4.3
haskell.compiler.ghc94                   ghc-9.4.4
haskell.compiler.ghcHEAD                 ghc-9.7.20221224
haskell.compiler.ghc8102Binary           ghc-binary-8.10.2
haskell.compiler.ghc8102BinaryMinimal    ghc-binary-8.10.2
haskell.compiler.ghc8107BinaryMinimal    ghc-binary-8.10.7
haskell.compiler.ghc8107Binary           ghc-binary-8.10.7
haskell.compiler.ghc865Binary            ghc-binary-8.6.5
haskell.compiler.ghc924Binary            ghc-binary-9.2.4
haskell.compiler.ghc924BinaryMinimal     ghc-binary-9.2.4
haskell.compiler.integer-simple.ghc810   ghc-integer-simple-8.10.7
haskell.compiler.integer-simple.ghc8107  ghc-integer-simple-8.10.7
haskell.compiler.integer-simple.ghc884   ghc-integer-simple-8.8.4
haskell.compiler.integer-simple.ghc88    ghc-integer-simple-8.8.4
haskell.compiler.native-bignum.ghc90     ghc-native-bignum-9.0.2
haskell.compiler.native-bignum.ghc902    ghc-native-bignum-9.0.2
haskell.compiler.native-bignum.ghc92     ghc-native-bignum-9.2.4
haskell.compiler.native-bignum.ghc924    ghc-native-bignum-9.2.4
haskell.compiler.native-bignum.ghc925    ghc-native-bignum-9.2.5
haskell.compiler.native-bignum.ghc942    ghc-native-bignum-9.4.2
haskell.compiler.native-bignum.ghc943    ghc-native-bignum-9.4.3
haskell.compiler.native-bignum.ghc94     ghc-native-bignum-9.4.4
haskell.compiler.native-bignum.ghc944    ghc-native-bignum-9.4.4
haskell.compiler.native-bignum.ghcHEAD   ghc-native-bignum-9.7.20221224
haskell.compiler.ghcjs                   ghcjs-8.10.7
```

Every of those compilers has a corresponding attribute set built completely
using it. However, the non-standard package sets are not tested regularly and
have less working packages as a result. The corresponding package set for GHC
9.4.4 is `haskell.packages.ghc944` (in fact `haskellPackages` is just an alias
for `haskell.packages.ghc924`):

```console
$ nix-env -f '<nixpkgs>' -qaP -A haskell.packages.ghc924
haskell.packages.ghc924.a50                                                         a50-0.5
haskell.packages.ghc924.AAI                                                         AAI-0.2.0.1
haskell.packages.ghc924.aasam                                                       aasam-0.2.0.0
haskell.packages.ghc924.abacate                                                     abacate-0.0.0.0
haskell.packages.ghc924.abc-puzzle                                                  abc-puzzle-0.2.1
…
```

Every package set also re-exposes the GHC used to build its packages as `haskell.packages.*.ghc`.

## `haskellPackages.mkDerivation` {#haskell-mkderivation}

Every haskell package set has its own haskell-aware `mkDerivation` which is used
to build its packages. Generally you won't have to interact with this builder
since [cabal2nix][cabal2nix] can generate packages
using it for an arbitrary cabal package definition. Still it is useful to know
the parameters it takes when you need to
[override](#sec-haskell-overriding-haskell-packages) a generated nix expression.

`haskellPackages.mkDerivation` is a wrapper around `stdenv.mkDerivation` which
re-defines the default phases to be haskell aware and handles dependency
specification, test suites, benchmarks etc. by compiling and invoking the
package's `Setup.hs`. It does *not* use or invoke the `cabal-install` binary,
but uses the underlying `Cabal` library instead.

### General arguments

`pname`
: Package name, assumed to be the same as on hackage (if applicable)

`version`
: Packaged version, assumed to be the same as on hackage (if applicable)

`src`
: Source of the package. If omitted, fetch package corresponding to `pname`
and `version` from hackage.

`sha256`
: Hash to use for the default case of `src`.

`revision`
: Revision number of the updated cabal file to fetch from hackage.
If `null` (which is the default value), the one included in `src` is used.

`editedCabalFile`
: `sha256` hash of the cabal file identified by `revision` or `null`.

`configureFlags`
: Extra flags passed when executing the `configure` command of `Setup.hs`.

`buildFlags`
: Extra flags passed when executing the `build` command of `Setup.hs`.

`haddockFlags`
: Extra flags passed to `Setup.hs haddock` when building the documentation.

`doCheck`
: Whether to execute the package's test suite if it has one. Defaults to `true` unless cross-compiling.

`doBenchmark`
: Whether to execute the package's benchmark if it has one. Defaults to `false`.

`doHoogle`
: Whether to generate an index file for [hoogle][hoogle] as part of
`haddockPhase` by passing the [`--hoogle` option][haddock-hoogle-option].
Defaults to `true`.

`doHaddockQuickjump`
: Whether to generate an index for interactive navigation of the HTML documentation.
Defaults to `true` if supported.

`enableLibraryProfiling`
: Whether to enable [profiling][profiling] for libraries contained in the
package. Enabled by default if supported.

`enableExecutableProfiling`
: Whether to enable [profiling][profiling] for executables contained in the
package. Disabled by default.

`profilingDetail`
: [Profiling detail level][profiling-detail] to set. Defaults to `exported-functions`.

`enableSharedExecutables`
: Whether to link executables dynamically. By default, executables are linked statically.

`enableSharedLibraries`
: Whether to build shared Haskell libraries. This is enabled by default unless we are using
`pkgsStatic` or shared libraries have been disabled in GHC.

`enableStaticLibraries`
: Whether to build static libraries. Enabled by default if supported.

`enableDeadCodeElimination`
: Whether to enable linker based dead code elimination in GHC.
Enabled by default if supported.

`enableHsc2hsViaAsm`
: Whether to pass `--via-asm` to `hsc2hs`.

`hyperlinkSource`
: Whether to render the source as well as part of the haddock documentation
by passing the [`--hyperlinked-source` flag][haddock-hyperlinked-source-option].
Defaults to `true`.

`isExecutable`
: Whether the package contains an executable.

`isLibrary`
: Whether the package contains a library.

`jailbreak`
: Whether to execute [jailbreak-cabal][jailbreak-cabal] before `configurePhase`
to lift any version constraints in the cabal file. Note that this can't
lift version bounds if they are conditional, e.g. if a dependency is hidden
behind a flag.

`enableParallelBuilding`
: Whether to use the `-j` flag to make GHC/Cabal start multiple jobs in parallel.

`maxBuildCores`
: Upper limit of jobs to use in parallel for compilation regardless of
`$NIX_BUILD_CORES`. Defaults to 16 as haskell compilation with GHC currently
sees a [performance regression](https://gitlab.haskell.org/ghc/ghc/-/issues/9221)
if too many parallel jobs are used.

`doCoverage`
: Whether to generate and install files needed for [HPC][haskell-program-coverage].
Defaults to `false`.

`doHaddock`
: Wether to build (HTML) documentation using [haddock][haddock].
Defaults to `true` if supported.

`testTarget`
: Name of the test suite to build and run. If unset, all test suites will be executed.

`preCompileBuildDriver`
: Shell code to run before compiling `Setup.hs`.

`postCompileBuildDriver`
: Shell code to run after compiling `Setup.hs`.

`preHaddock`
: Shell code to run before building documentation using haddock.

`postHaddock`
: Shell code to run after building documentation using haddock.

`coreSetup`
: Whether to only allow core libraries to be used while building `Setup.hs`.
Defaults to `false`.

`useCpphs`
: Whether to enable the [cpphs][cpphs] preprocessor. Defaults to `false`.

`enableSeparateBinOutput`
: Whether to install executables to a separate `bin` output. Defaults to `false`.

`enableSeparateDataOutput`
: Whether to install data files shipped with the package to a separate `data` output.
Defaults to `false`.

`enableSeparateDocOutput`
: Whether to install documentation to a separate `doc` output.
Is automatically enabled if `doHaddock` is `true`.

`allowInconsistentDependencies`
: If enabled, allow multiple versions of the same package at configure time.
Usually in such a situation compilation would later fail. Defaults to `false`.

`enableLibraryForGhci`
: Build and install a special object file for GHCi. This improves performance
when loading the library in the REPL, but requires extra build time and
disk space. Defaults to `false`.

`buildTarget`
: Name of the executable or library to build and install.
If unset, all available targets are built and installed.

### Specifying dependencies

Since `haskellPackages.mkDerivation` is intended to be generated from cabal
files, it reflects cabal's way of specifying dependencies. For one, dependencies
are grouped by what part of the package they belong to. This helps to reduce the
dependency closure of a derivation, for example benchmark dependencies are not
included if `doBenchmark == false`.

`setup*Depends`
: dependencies necessary to compile `Setup.hs`

`library*Depends`
: dependencies of a library contained in the package

`executable*Depends`
: dependencies of an executable contained in the package

`test*Depends`
: dependencies of a test suite contained in the package

`benchmark*Depends`
: dependencies of a benchmark contained in the package

The other categorization relates to the way the package depends on the dependency:

`*ToolDepends`
: Tools we need to run as part of the build process.
They are added to the derivation's `nativeBuildInputs`.

`*HaskellDepends`
: Haskell libraries the package depends on.
They are added to `propagatedBuildInputs`.

`*SystemDepends`
: Non-Haskell libraries the package depends on.
They are added to `buildInputs`

`*PkgconfigDepends`
: `*SystemDepends` which are discovered using `pkg-config`.
They are added to `buildInputs` and it is additionally
ensured that `pkg-config` is available at build time.

`*FrameworkDepends`
: Apple SDK Framework which the package depends on when compiling it on Darwin.

Using these two distinctions, you should be able to categorize most of the dependency
specifications that are available:
`benchmarkFrameworkDepends`,
`benchmarkHaskellDepends`,
`benchmarkPkgconfigDepends`,
`benchmarkSystemDepends`,
`benchmarkToolDepends`,
`executableFrameworkDepends`,
`executableHaskellDepends`,
`executablePkgconfigDepends`,
`executableSystemDepends`,
`executableToolDepends`,
`libraryFrameworkDepends`,
`libraryHaskellDepends`,
`libraryPkgconfigDepends`,
`librarySystemDepends`,
`libraryToolDepends`,
`setupHaskellDepends`,
`testFrameworkDepends`,
`testHaskellDepends`,
`testPkgconfigDepends`,
`testSystemDepends` and
`testToolDepends`.

That only leaves the following extra ways for specifying dependencies:

`buildDepends`
: Allows specifying Haskell dependencies which are added to `propagatedBuildInputs` unconditionally.

`buildTools`
: Like `*ToolDepends`, but are added to `nativeBuildInputs` unconditionally.

`extraLibraries`
: Like `*SystemDepends`, but are added to `buildInputs` unconditionally.

`pkg-configDepends`
: Like `*PkgconfigDepends`, but are added to `buildInputs` unconditionally.

`testDepends`
: Deprecated, use either `testHaskellDepends` or `testSystemDepends`.

`benchmarkDepends`
: Deprecated, use either `benchmarkHaskellDepends` or `benchmarkSystemDepends`.

The dependency specification methods in this list which are unconditional
are especially useful when writing [overrides](#sec-haskell-overriding-haskell-packages)
when you want to make sure that they are definitely included. However, it is
recommended to use the more accurate ones listed above when possible.

### Meta attributes

`haskellPackages.mkDerivation` accepts the following attributes as direct
arguments which are transparently set in `meta` of the resulting derivation. See
the [Meta-attributes section](#chap-meta) for their documentation.

* These attributes are populated with a default value if omitted:
    * `homepage`: defaults to the hackage page for `pname`.
    * `platforms`: defaults to `lib.platforms.all` (since GHC can cross-compile)
* These attributes are only set if given:
    * `description`
    * `license`
    * `changelog`
    * `maintainers`
    * `broken`
    * `hydraPlatforms`

## Development environments {#sec-haskell-development-environments}

In addition to building and installing Haskell software, nixpkgs can also
provide development environments for Haskell projects. This has the obvious
advantage that you benefit from `cache.nixos.org` and no longer need to compile
all project dependencies yourself.

Our main objective with `haskellPackages` is to package Haskell software in
nixpkgs. This entails some limitations, partially due to self-imposed
restrictions of nixpkgs, partially in the name of maintainability:

* Only the packages built with the default compiler see extensive testing of the
  whole package set. The experience using an older or newer packaged compiler
  may be worse.

* We aim for a “blessed” package set which only contains one version of each
  package.

Thus, to get the best experience, make sure that your project can be compiled
using the default compiler of nixpkgs and recent versions of its dependencies.
“Recent” can either mean the version contained in a certain [Stackage] snapshot
(usually the latest LTS or nightly one) <!-- TODO(@sternenseemann): document our use of solvers -->
or the latest version from Hackage. Similarly to Stackage, we sometimes
intervene and downgrade packages to ensure as many packages as possible can
be compiled together.

In particular, it is not possible to get the dependencies of a legacy project
from nixpkgs or to use a specific stack solver for compiling a project.

Now for the actual development environments: By default every derivation built
using [`haskellPackages.mkDerivation`](#haskell-mkderivation) exposes an
environment suitable for building it interactively as the `env` attribute. For
example, if you have a local checkout of `random`, you can enter a development
environment for it like this (if the dependencies in the development and
packaged version match):

```console
$ cd ~/src/random
$ nix-shell -A haskellPackages.random.env '<nixpkgs>'
[nix-shell:~/src/random]$ ghc-pkg list
/nix/store/a8hhl54xlzfizrhcf03c1l3f6l9l8qwv-ghc-9.2.4-with-packages/lib/ghc-9.2.4/package.conf.d
    Cabal-3.6.3.0
    array-0.5.4.0
    base-4.16.3.0
    binary-0.8.9.0
    …
    ghc-9.2.4
    …
```

As you can see, the environment contains a GHC which is set up so it finds all
dependencies of `random`. Note that this environment does not mirror
the environment used to build the package, but is intended as a convenient
tool for development and simple debugging. `env` relies on the `ghcWithPackages`
wrapper which automatically injects a pre-populated package-db into every
GHC invocation. When building the derivation, the appropriate flags would always
be passed explicitly.

`env` mirrors the normal derivation environment in one aspect: It does not include
familiar development tools like `cabal-install`, since we rely on plain `Setup.hs`
to build all packages. However, `cabal-install` will work as expected if in
`PATH` (e.g. when installed globally and using a `nix-shell` without `--pure`).
A declarative and pure way of adding arbitrary development tools is provided
via [`shellFor`](#ssec-haskell-shellFor).

<!-- TODO(@sternenseemann): this doesn't work in practice (anymore?)
This topic needs to be investigated again; Deleting the local hackage db is
an easy workaround (ty @maralorn), but some useful features of cabal2nix
depend on it (i.e. cabal2nix cabal://pkg-version).

You can make sure that `cabal-install` doesn't download or build any packages
not provided using Nix by passing `--offline`. There is of course a better way
to add any number of development tools to your `nix-shell` which we'll discuss
later.

-->

Often you won't work on a package that is already part of `haskellPackages` or
Hackage, so we first need to write a Nix expression to obtain the development
environment from. Luckily, we can generate one very easily from an already
existing cabal file using `cabal2nix`:

```console
$ ls
my-project.cabal src …
$ cabal2nix ./. > my-project.nix
```

The generated nix expression evaluates to a function ready to be
`callPackage`-ed. For now, we can add a minimal `default.nix` which does just
that:

```nix
# Retrieve nixpkgs impurely from NIX_PATH for now, you can pin it instead, of course.
{ pkgs ? import <nixpkgs> {} }:

# use the nixpkgs default haskell package set
pkgs.haskellPackages.callPackage ./my-project.nix { }
```

Using `nix-build default.nix` we can now build our project, but we can also
enter a shell with all the package's dependencies available using `nix-shell
-A env default.nix`. If you have `cabal-install` installed globally, it'll work
inside the shell as expected.

### shellFor {#ssec-haskell-shellFor}

Having to install tools globally is obviously not great, especially if you want
to provide a batteries-included `shell.nix` with your project. Luckily there's a
proper tool for making development environments out of packages' build
environments: `shellFor`, a function exposed by every haskell package set. It
takes the following arguments and returns a derivation which is suitable as a
development environment inside `nix-shell`:

`packages`
: This argument is used to select the packages for which to build the
development environment. This should be a function which takes a haskell package
set and returns a list of packages. `shellFor` will pass the used package set to
this function and include all dependencies of the returned package in the build
environment. This means you can reuse nix expressions of packages included in
nixpkgs, but also use local nix expressions like this: `hpkgs: [
(hpkgs.callPackage ./my-project.nix { }) ]`.

`nativeBuildInputs`
: Expects a list of derivations to add as build tools to the build environment.
This is the place to add packages like `cabal-install`, `doctest` or `hlint`.
Defaults to `[]`.

`buildInputs`
: Expects a list of derivations to add as library dependencies, like `openssl`.
This is rarely necessary as the haskell package expressions usually track system
dependencies as well. Defaults to `[]`.

<!-- TODO link specifying deps section here -->

`withHoogle`
: If this is true, `hoogle` will be added to `nativeBuildInputs`.
Additionally, its database will be populated with all included dependencies,
so you'll be able search through the documentation of your dependencies.
Defaults to `false`.

`genericBuilderArgsModifier`
: This argument accepts a function allowing you to modify the arguments passed
to `mkDerivation` in order to create the development environment. For example,
`args: { doCheck = false; }` would cause the environment to not include any test
dependencies. Defaults to `lib.id`.

`doBenchmark`
: This is a shortcut for enabling `doBenchmark` via `genericBuilderArgsModifier`.
Setting it to `true` will cause the development environment to include all
benchmark dependencies which would be excluded by default. Defaults to `false`.

One neat property of `shellFor` is that it allows you to work on multiple
packages using the same environment in conjunction with
[cabal.project files][cabal-project-files].
Say our example above depends on `distribution-nixpkgs` and we have a project
file set up for both, we can add the following `shell.nix` expression:

```nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.haskellPackages.shellFor {
  packages = hpkgs: [
    # reuse the nixpkgs for this package
    hpkgs.distribution-nixpkgs
    # call our generated nix expression manually
    (hpkgs.callPackage ./my-project/my-project.nix { })
  ];

  # development tools we use
  nativeBuildInputs = [
    pkgs.cabal-install
    pkgs.haskellPackages.doctest
    pkgs.cabal2nix
  ];

  # Extra arguments are added to mkDerivation's arguments as-is.
  # Since it adds all passed arguments to the shell environment,
  # we can use this to set the environment variable the `Paths_`
  # module of distribution-nixpkgs uses to search for bundled
  # files.
  # See also: https://cabal.readthedocs.io/en/latest/cabal-package.html#accessing-data-files-from-package-code
  distribution_nixpkgs_datadir = toString ./distribution-nixpkgs;
}
```

<!-- TODO(@sternenseemann): deps are not included if not selected -->

## Overriding haskell packages {#sec-haskell-overriding-haskell-packages}

### Overriding a single package

<!-- TODO(@sternenseemann): we should document /somewhere/ that base == null etc. -->

Like many language specific subsystems in nixpkgs, the Haskell infrastructure
also has its own quirks when it comes to overriding. Overriding of the *inputs*
to a package at least follows the standard procedure. For example, imagine you
need to build `nix-tree` with a more recent version of `brick` than the default
one provided by `haskellPackages`:

```nix
haskellPackages.nix-tree.override {
  brick = haskellPackages.brick_0_67;
}
```

<!-- TODO(@sternenseemann): This belongs in the next section
One common problem you may run into with such an override is the build failing
with “abort because of serious configure-time warning from Cabal”. When scrolling
up, you'll usually notice that Cabal noticed that more than one versions of the same
package was present in the dependency graph. This typically causes a later compilation
failure (the error message `haskellPackages.mkDerivation` produces tries to save
you the time of finding this out yourself, but if you wish to do so, you can
disable it using `allowInconsistentDependencies`). Luckily, `haskellPackages` provides
you with a tool to deal with this. `overrideScope` creates a new `haskellPackages`
instance with the override applied *globally* for this package, so the dependency
closure automatically uses a consistent version of the overridden package. E. g.
if `haskell-ci` needs a recent version of `Cabal`, but also uses other packages
that depend on that library, you may want to use:

```nix
haskellPackages.haskell-ci.overrideScope (self: super: {
  Cabal = self.Cabal_3_6_2_0;
})
```

-->

The custom interface comes into play when you want to override the arguments
passed to `haskellPackages.mkDerivation`. For this, the function `overrideCabal`
from `haskell.lib.compose` is used. E.g. if you want to install a man page
that is distributed with the package, you can do something like this:

```nix
haskell.lib.compose.overrideCabal (drv: {
  postInstall = ''
    ${drv.postInstall or ""}
    install -Dm644 man/pnbackup.1 -t $out/share/man/man1
  '';
}) haskellPackages.pnbackup
```

`overrideCabal` takes two arguments:

1. A function which receives all arguments passed to `haskellPackages.mkDerivation`
   before and returns a set of arguments to replace (or add) with a new value.
2. The Haskell derivation to override.

The arguments are ordered so that you can easily create helper functions by making
use of currying:

```nix
let
  installManPage = haskell.lib.compose.overrideCabal (drv: {
    postInstall = ''
      ${drv.postInstall or ""}
      install -Dm644 man/${drv.pname}.1 -t "$out/share/man/man1"
    '';
  });
in

installManPage haskellPackages.pnbackup
```

In fact, `haskell.lib.compose` already provides lots of useful helpers for common
tasks, detailed in the next section. They are also structured in such a way that
they can be combined using `lib.pipe`:

```nix
lib.pipe my-haskell-package [
  # lift version bounds on dependencies
  haskell.lib.compose.doJailbreak
  # disable building the haddock documentation
  haskell.lib.compose.dontHaddock
  # pass extra package flag to Cabal's configure step
  (haskell.lib.compose.enableCabalFlag "myflag")
]
```

#### `haskell.lib.compose`

The base interface for all overriding is the following function:

`overrideCabal f drv`
: Takes the arguments passed to obtain `drv` to `f` and uses the resulting
attribute set to update the argument set. Then a recomputed version of `drv`
using the new argument set is returned.

<!--
TODO(@sternenseemann): ideally we want to be more detailed here as well, but
I want to avoid the documentation having to be kept in sync in too many places.
We already document this stuff in the mkDerivation section and lib/compose.nix.
Ideally this section would be generated from the latter in the future.
-->

All other helper functions are implemented in terms of `overrideCabal` and make
common overrides shorter and more complicate ones trivial. The simple overrides
which only change a single argument are only described very briefly in the
following overview. Refer to the
[documentation of `haskellPackages.mkDerivation`](#haskell-mkderivation)
for a more detailed description of the effects of the respective arguments.

##### Packaging Helpers

`overrideSrc { src, version } drv`
: Replace the source used for building `drv` with the path or derivation given
as `src`. The `version` attribute is optional. Prefer this function over
overriding `src` via `overrideCabal`, since it also automatically takes care of
removing any Hackage revisions.

<!-- TODO(@sternenseemann): deprecated

`generateOptparseApplicativeCompletions list drv`
: Generate and install shell completion files for the installed executables whose
names are given via `list`. The executables need to be using `optparse-applicative`
for this to work.
-->

`justStaticExecutables drv`
: Only build and install the executables produced by `drv`, removing everything
that may refer to other Haskell packages' store paths (like libraries and
documentation). This dramatically reduces the closure size of the resulting
derivation. Note that the executables are only statically linked against their
Haskell dependencies, but will still link dynamically against libc, GMP and
other system library dependencies. If dependencies use their Cabal-generated
`Paths_*` module, this may not work as well if GHC's dead code elimination
is unable to remove the references to the dependency's store path that module
contains.

`enableSeparateBinOutput drv`
: Install executables produced by `drv` to a separate `bin` output. This
has a similar effect as `justStaticExecutables`, but preserves the libraries
and documentation in the `out` output alongside the `bin` output with a
much smaller closure size.

`markBroken drv`
: Sets the `broken` flag to `true` for `drv`.

`markUnbroken drv`, `unmarkBroken drv`
: Set the `broken` flag to `false` for `drv`.

`doDistribute drv`
: Updates `hydraPlatforms` so that Hydra will build `drv`. This is
sometimes necessary when working with versioned packages in
`haskellPackages` which are not built by default.

`dontDistribute drv`
: Sets `hydraPlatforms` to `[]`, causing Hydra to skip this package
altogether. Useful if it fails to evaluate cleanly and is causing
noise in the evaluation errors tab on Hydra.

##### Development Helpers

`sdistTarball drv`
: Create a source distribution tarball like those found on Hackage
instead of building the package `drv`.

`documentationTarball drv`
: Create a documentation tarball suitable for uploading to Hackage
instead of building the package `drv`.

`buildFromSdist drv`
: Uses `sdistTarball drv` as the source to compile `drv`. This helps to catch
packaging bugs when building from a local directory, e.g. when required files
are missing from `extra-source-files`.

`failOnAllWarnings drv`
: Enables all warnings GHC supports and makes it fail the build if any of them
are emitted.

<!-- TODO(@sternenseemann):
`checkUnusedPackages opts drv`
: Adds an extra check to `postBuild` which fails the build if any dependency
taken as an input is not used. The `opts` attribute set allows relaxing this
check.
-->

`enableDWARFDebugging drv`
: Compiles the package with additional debug symbols enabled, useful
for debugging with e.g. `gdb`.

`doStrip drv`
: Sets `doStrip` to `true` for `drv`.

`dontStrip drv`
: Sets `doStrip` to `false` for `drv`.

<!-- TODO(@sternenseemann): shellAware -->

##### Trivial Helpers

`doJailbreak drv`
: Sets the `jailbreak` argument to `true` for `drv`.

`dontJailbreak drv`
: Sets the `jailbreak` argument to `false` for `drv`.

`doHaddock drv`
: Sets `doHaddock` to `true` for `drv`.

`dontHaddock drv`
: Sets `doHaddock` to `false` for `drv`. Useful if the build of a package is
failing because of e.g. a syntax error in the Haddock documentation.

`doHyperlinkSource drv`
: Sets `hyperlinkSource` to `true` for `drv`.

`dontHyperlinkSource drv`
: Sets `hyperlinkSource` to `false` for `drv`.

`doCheck drv`
: Sets `doCheck` to `true` for `drv`.

`dontCheck drv`
: Sets `doCheck` to `false` for `drv`. Useful if a package has a broken,
flaky or otherwise problematic test suite breaking the build.

<!-- Purposefully omitting the non-list variants here. They are a bit
ugly, and we may want to deprecate them at some point. -->

`appendConfigureFlags list drv`
: Adds the strings in `list` to the `configureFlags` argument for `drv`.

`enableCabalFlag flag drv`
: Makes sure that the Cabal flag `flag` is enabled in Cabal's configure step.

`disableCabalFlag flag drv`
: Makes sure that the Cabal flag `flag` is disabled in Cabal's configure step.

`appendBuildflags list drv`
: Adds the strings in `list` to the `buildFlags` argument for `drv`.

<!-- TODO(@sternenseemann): removeConfigureFlag -->

`appendPatches list drv`
: Adds the `list` of derivations or paths to the `patches` argument for `drv`.

<!-- TODO(@sternenseemann): link dep section -->

`addBuildTools list drv`
: Adds the `list` of derivations to the `buildTools` argument for `drv`.

`addExtraLibraries list drv`
: Adds the `list` of derivations to the `extraLibraries` argument for `drv`.

`addBuildDepends list drv`
: Adds the `list` of derivations to the `buildDepends` argument for `drv`.

`addTestToolDepends list drv`
: Adds the `list` of derivations to the `testToolDepends` argument for `drv`.

`addPkgconfigDepends list drv`
: Adds the `list` of derivations to the `pkg-configDepends` argument for `drv`.

`addSetupDepends list drv`
: Adds the `list` of derivations to the `setupHaskellDepends` argument for `drv`.

`doBenchmark drv`
: Set `doBenchmark` to `true` for `drv`. Useful if your development
environment is missing the dependencies necessary for compiling the
benchmark component.

`dontBenchmark drv`
: Set `doBenchmark` to `false` for `drv`.

`setBuildTargets list drv`
: Sets the `buildTarget` argument for `drv` so that the targets specified in `list` are built.

`doCoverage drv`
: Sets the `doCoverage` argument to `true` for `drv`.

`dontCoverage drv`
: Sets the `doCoverage` argument to `false` for `drv`.

#### Library functions in the Haskell package sets

Some library functions depend on packages from the Haskell package sets. Thus they are
exposed from those instead of from `haskell.lib.compose` which can only access what is
passed directly to it. When using the functions below, make sure that you are obtaining them
from the same package set (`haskellPackages`, `haskell.packages.ghc944` etc.) as the packages
you are working with or – even better – from the `self`/`final` fix point of your overlay to
`haskellPackages`.

Note: Some functions like `shellFor` that are not intended for overriding per se, are omitted
in this section. <!-- TODO(@sternenseemann): note about ifd section -->

`cabalSdist { src, name }`
: Generates the Cabal sdist tarball for `src`, suitable for uploading to Hackage.
Contrary to `haskell.lib.compose.sdistTarball`, it uses `cabal-install` over `Setup.hs`,
so it is usually faster: No build dependencies need to be downloaded and we can
skip compiling `Setup.hs`.

`buildFromCabalSdist drv`
: Build `drv`, but run its `src` attribute through `cabalSdist` first. Useful for catching
files necessary for compilation that are missing from the sdist.

`generateOptparseApplicativeCompletions list drv`
: Generate and install shell completion files for the installed executables whose
names are given via `list`. The executables need to be using `optparse-applicative`
for [this to work][optparse-applicative-completions].
Note that this feature is automatically disabled when cross-compiling, since it
requires executing the binaries in question.

<!--

TODO(@NixOS/haskell): finish these planned sections
### Overriding the entire package set


## Import-from-Derivation helpers

* `callCabal2nix`
* `callHackage`, `callHackageDirect`
* `developPackage`

## Contributing {#sec-haskell-contributing}

### Fixing a broken package {#sec-haskell-fixing-a-broken-package}

### Package set generation {#sec-haskell-package-set-generation}

### Packaging a Haskell project

### Backporting {#sec-haskell-backporting}

Backporting changes to a stable NixOS version in general is covered
in nixpkgs' `CONTRIBUTING.md` in general. In particular refer to the
[backporting policy](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md#criteria-for-backporting-changes)
to check if the change you have in mind may be backported.

This section focuses on how to backport a package update (e.g. a
bug fix or security release). Fixing a broken package works like
it does for the unstable branches.

-->

## F.A.Q. {#sec-haskell-faq}

### Why is topic X not covered in this section? Why is section Y missing?

We have been working on [moving the nixpkgs Haskell documentation back into the
nixpkgs manual](https://github.com/NixOS/nixpkgs/issues/121403). Since this
process has not been completed yet, you may find some topics missing here
covered in the old [haskell4nix docs](https://haskell4nix.readthedocs.io/).

If you feel any important topic is not documented at all, feel free to comment
on the issue linked above.

[Stackage]: https://www.stackage.org
[cabal2nix]: https://github.com/nixos/cabal2nix
[hoogle]: https://wiki.haskell.org/Hoogle
[haddock]: https://www.haskell.org/haddock/
[haddock-hoogle-option]: https://haskell-haddock.readthedocs.io/en/latest/invoking.html#cmdoption-hoogle
[haddock-hyperlinked-source-option]: https://haskell-haddock.readthedocs.io/en/latest/invoking.html#cmdoption-hyperlinked-source
[profiling]: https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/profiling.html
[haskell-program-coverage]: https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/profiling.html#observing-code-coverage
[profiling-detail]: https://cabal.readthedocs.io/en/latest/cabal-project.html#cfg-field-profiling-detail
[jailbreak-cabal]: https://github.com/NixOS/jailbreak-cabal/
[cpphs]: https://hackage.haskell.org/package/cpphs
[cabal-project-files]: https://cabal.readthedocs.io/en/latest/cabal-project.html
[optparse-applicative-completions]: https://github.com/pcapriotti/optparse-applicative/blob/7726b63796aa5d0df82e926d467f039b78ca09e2/README.md#bash-zsh-and-fish-completions
