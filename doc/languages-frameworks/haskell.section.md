# Haskell {#haskell}

The Haskell infrastructure in Nixpkgs has two main purposes: The primary purpose
is to provide a Haskell compiler and build tools as well as infrastructure for
packaging Haskell-based packages.

The secondary purpose is to provide support for Haskell development environments
including prebuilt Haskell libraries. However, in this area sacrifices have been
made due to self-imposed restrictions in Nixpkgs, to lessen the maintenance
effort and to improve performance. (More details in the subsection
[Limitations.](#haskell-limitations))

## Available packages {#haskell-available-packages}

The compiler and most build tools are exposed at the top level:

* `ghc` is the default version of GHC
* Language specific tools: `cabal-install`, `stack`, `hpack`, …

Many “normal” user facing packages written in Haskell, like `niv` or `cachix`,
are also exposed at the top level, and there is nothing Haskell specific to
installing and using them.

All of these packages are originally defined in the `haskellPackages` package
set and are re-exposed with a reduced dependency closure for convenience.
(see `justStaticExecutables` below)

The `haskellPackages` set includes at least one version of every package from
Hackage as well as some manually injected packages. This amounts to a lot of
packages, so it is hidden from `nix-env -qa` by default for performance reasons.
You can still list all packages in the set like this:

```console
$ nix-env -f '<nixpkgs>' -qaP -A haskellPackages
haskellPackages.a50                                                         a50-0.5
haskellPackages.AAI                                                         AAI-0.2.0.1
haskellPackages.aasam                                                       aasam-0.2.0.0
haskellPackages.abacate                                                     abacate-0.0.0.0
haskellPackages.abc-puzzle                                                  abc-puzzle-0.2.1
…
```
Also, the `haskellPackages` set is included on [search.nixos.org].

The attribute names in `haskellPackages` always correspond with their name on
Hackage. Since Hackage allows names that are not valid Nix without escaping,
you need to take care when handling attribute names like `3dmodels`.

For packages that are part of [Stackage], we use the version prescribed by a
Stackage solver (usually the current LTS one) as the default version. For all
other packages we use the latest version from Hackage. See
[below](#haskell-available-versions) to learn which versions are provided
exactly.

Roughly half of the 16K packages contained in `haskellPackages` don't actually
build and are marked as broken semi-automatically. Most of those packages are
deprecated or unmaintained, but sometimes packages that should build, do not
build. Very often fixing them is not a lot of work.

<!--
TODO(@sternenseemann):
How you can help with that is
described in [Fixing a broken package](#haskell-fixing-a-broken-package).
-->

`haskellPackages` is built with our default compiler, but we also provide other
releases of GHC and package sets built with them. You can list all available
compilers like this:

```console
$ nix-env -f '<nixpkgs>' -qaP -A haskell.compiler
haskell.compiler.ghc810                  ghc-8.10.7
haskell.compiler.ghc88                   ghc-8.8.4
haskell.compiler.ghc90                   ghc-9.0.2
haskell.compiler.ghc924                  ghc-9.2.4
haskell.compiler.ghc925                  ghc-9.2.5
haskell.compiler.ghc926                  ghc-9.2.6
haskell.compiler.ghc92                   ghc-9.2.7
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
haskell.compiler.integer-simple.ghc88    ghc-integer-simple-8.8.4
haskell.compiler.integer-simple.ghc884   ghc-integer-simple-8.8.4
haskell.compiler.native-bignum.ghc90     ghc-native-bignum-9.0.2
haskell.compiler.native-bignum.ghc902    ghc-native-bignum-9.0.2
haskell.compiler.native-bignum.ghc924    ghc-native-bignum-9.2.4
haskell.compiler.native-bignum.ghc925    ghc-native-bignum-9.2.5
haskell.compiler.native-bignum.ghc926    ghc-native-bignum-9.2.6
haskell.compiler.native-bignum.ghc92     ghc-native-bignum-9.2.7
haskell.compiler.native-bignum.ghc927    ghc-native-bignum-9.2.7
haskell.compiler.native-bignum.ghc942    ghc-native-bignum-9.4.2
haskell.compiler.native-bignum.ghc943    ghc-native-bignum-9.4.3
haskell.compiler.native-bignum.ghc94     ghc-native-bignum-9.4.4
haskell.compiler.native-bignum.ghc944    ghc-native-bignum-9.4.4
haskell.compiler.native-bignum.ghcHEAD   ghc-native-bignum-9.7.20221224
haskell.compiler.ghcjs                   ghcjs-8.10.7
```

Each of those compiler versions has a corresponding attribute set built using
it. However, the non-standard package sets are not tested regularly and, as a
result, contain fewer working packages. The corresponding package set for GHC
9.4.5 is `haskell.packages.ghc945`. In fact `haskellPackages` is just an alias
for `haskell.packages.ghc927`:

```console
$ nix-env -f '<nixpkgs>' -qaP -A haskell.packages.ghc927
haskell.packages.ghc927.a50                                                         a50-0.5
haskell.packages.ghc927.AAI                                                         AAI-0.2.0.1
haskell.packages.ghc927.aasam                                                       aasam-0.2.0.0
haskell.packages.ghc927.abacate                                                     abacate-0.0.0.0
haskell.packages.ghc927.abc-puzzle                                                  abc-puzzle-0.2.1
…
```

Every package set also re-exposes the GHC used to build its packages as `haskell.packages.*.ghc`.

### Available package versions {#haskell-available-versions}

We aim for a “blessed” package set which only contains one version of each
package, like Stackage (and based on it) but with more packages. Normally in
nixpkgs the number of building Haskell packages is roughly two to three times
the size of Stackage. For choosing the version to use for a certain package we
use the following rules:

1. By default, for every package `haskellPackages.foo` is the newest version
found on Hackage (at the time of the last update of our package set).
2. If the Stackage snapshot that we use (usually the newest LTS snapshot)
contains a package, we use the Stackage version as default version for that
package.
3. For some packages, which are not on Stackage, we have manual overrides to
set the default version to a version older than the newest on Hackage. We do
this to get them or their reverse dependencies to compile in our package set.
4. For all packages, for which the newest Hackage version is not the default
version, there will also be a `haskellPackages.foo_x_y_z` package with the
newest version. The `x_y_z` part encodes the version with dots replaced by
underscores. When the newest version changes by a new release to Hackage the
old package will disappear under that name and be replaced by a newer one under
the name with the new version. The package name including the version will
also disappear when the default version e.g. from Stackage catches up with the
newest version from Hackage.
5. For some packages, we also manually add other `haskellPackages.foo_x_y_z`
versions, if they are required for a certain build.

Relying on `haskellPackages.foo_x_y_z` attributes in derivations outside
nixpkgs is discouraged because they may change or disappear with every package
set update.
<!-- TODO(@maralorn) We should add a link to callHackage, etc. once we added
them to the docs. -->

All `haskell.packages.*` package sets use the same package descriptions and the same sets
of versions by default. There are however GHC version specific override `.nix`
files to loosen this a bit.

### Dependency resolution {#haskell-dependency-resolution}

Normally when you build Haskell packages with `cabal-install`, `cabal-install`
does dependency resolution. It will look at all Haskell package versions known
on Hackage and tries to pick for every (transitive) dependency of your build
exactly one version. Those versions need to satisfy all the version constraints
given in the `.cabal` file of your package and all its dependencies.

The [Haskell builder in nixpkgs](#haskell-mkderivation) does no such thing.
It will simply take as input packages with names off the desired dependencies
and just check whether they fulfill the version bounds and fail if they don’t
(by default, see `jailbreak` to circumvent this).

The `haskellPackages.callPackage` function does the package resolution.
It will, e.g., use `haskellPackages.aeson`which has the default version as
described above for a package input of name `aeson`. (More general:
`<packages>.callPackage f` will call `f` with named inputs provided from the
package set `<packages>`.)
While this is the default behavior, it is possible to override the dependencies
for a specific package, see
[`override` and `overrideScope`](#haskell-overriding-haskell-packages).

### Limitations {#haskell-limitations}

Our main objective with `haskellPackages` is to package Haskell software in
nixpkgs. This entails some limitations, partially due to self-imposed
restrictions of nixpkgs, partially in the name of maintainability:

* Only the packages built with the default compiler see extensive testing of the
  whole package set. For other GHC versions only a few essential packages are
  tested and cached.
* As described above we only build one version of most packages.

The experience using an older or newer packaged compiler or using different
versions may be worse, because builds will not be cached on `cache.nixos.org`
or may fail.

Thus, to get the best experience, make sure that your project can be compiled
using the default compiler of nixpkgs and recent versions of its dependencies.

A result of this setup is, that getting a valid build plan for a given
package can sometimes be quite painful, and in fact this is where most of the
maintenance work for `haskellPackages` is required. Besides that, it is not
possible to get the dependencies of a legacy project from nixpkgs or to use a
specific stack solver for compiling a project.

Even though we couldn’t use them directly in nixpkgs, it would be desirable
to have tooling to generate working Nix package sets from build plans generated
by `cabal-install` or a specific Stackage snapshot via import-from-derivation.
Sadly we currently don’t have tooling for this. For this you might be
interested in the alternative [haskell.nix] framework, which, be warned, is
completely incompatible with packages from `haskellPackages`.

<!-- TODO(@maralorn) Link to package set generation docs in the contributers guide below. -->

## `haskellPackages.mkDerivation` {#haskell-mkderivation}

Every haskell package set has its own haskell-aware `mkDerivation` which is used
to build its packages. Generally you won't have to interact with this builder
since [cabal2nix][cabal2nix] can generate packages
using it for an arbitrary cabal package definition. Still it is useful to know
the parameters it takes when you need to
[override](#haskell-overriding-haskell-packages) a generated Nix expression.

`haskellPackages.mkDerivation` is a wrapper around `stdenv.mkDerivation` which
re-defines the default phases to be haskell aware and handles dependency
specification, test suites, benchmarks etc. by compiling and invoking the
package's `Setup.hs`. It does *not* use or invoke the `cabal-install` binary,
but uses the underlying `Cabal` library instead.

### General arguments {#haskell-derivation-args}

`pname`
: Package name, assumed to be the same as on Hackage (if applicable)

`version`
: Packaged version, assumed to be the same as on Hackage (if applicable)

`src`
: Source of the package. If omitted, fetch package corresponding to `pname`
and `version` from Hackage.

`sha256`
: Hash to use for the default case of `src`.

`revision`
: Revision number of the updated cabal file to fetch from Hackage.
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
: Whether to pass `--via-asm` to `hsc2hs`. Enabled by default only on Windows.

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
lift version bounds if they are conditional, i.e. if a dependency is hidden
behind a flag.

`enableParallelBuilding`
: Whether to use the `-j` flag to make GHC/Cabal start multiple jobs in parallel.

`maxBuildCores`
: Upper limit of jobs to use in parallel for compilation regardless of
`$NIX_BUILD_CORES`. Defaults to 16 as Haskell compilation with GHC currently
sees a [performance regression](https://gitlab.haskell.org/ghc/ghc/-/issues/9221)
if too many parallel jobs are used.

`doCoverage`
: Whether to generate and install files needed for [HPC][haskell-program-coverage].
Defaults to `false`.

`doHaddock`
: Whether to build (HTML) documentation using [haddock][haddock].
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
: If enabled, allow multiple versions of the same Haskell package in the
dependency tree at configure time. Often in such a situation compilation would
later fail because of type mismatches. Defaults to `false`.

`enableLibraryForGhci`
: Build and install a special object file for GHCi. This improves performance
when loading the library in the REPL, but requires extra build time and
disk space. Defaults to `false`.

`buildTarget`
: Name of the executable or library to build and install.
If unset, all available targets are built and installed.

### Specifying dependencies {#haskell-derivation-deps}

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
are especially useful when writing [overrides](#haskell-overriding-haskell-packages)
when you want to make sure that they are definitely included. However, it is
recommended to use the more accurate ones listed above when possible.

### Meta attributes {#haskell-derivation-meta}

`haskellPackages.mkDerivation` accepts the following attributes as direct
arguments which are transparently set in `meta` of the resulting derivation. See
the [Meta-attributes section](#chap-meta) for their documentation.

* These attributes are populated with a default value if omitted:
    * `homepage`: defaults to the Hackage page for `pname`.
    * `platforms`: defaults to `lib.platforms.all` (since GHC can cross-compile)
* These attributes are only set if given:
    * `description`
    * `license`
    * `changelog`
    * `maintainers`
    * `broken`
    * `hydraPlatforms`

## Development environments {#haskell-development-environments}

In addition to building and installing Haskell software, nixpkgs can also
provide development environments for Haskell projects. This has the obvious
advantage that you benefit from `cache.nixos.org` and no longer need to compile
all project dependencies yourself. While it is often very useful, this is not
the primary use case of our package set. Have a look at the section
[available package versions](#haskell-available-versions) to learn which
versions of packages we provide and the section
[limitations](#haskell-limitations), to judge whether a `haskellPackages`
based development environment for your project is feasible.

By default, every derivation built using
[`haskellPackages.mkDerivation`](#haskell-mkderivation) exposes an environment
suitable for building it interactively as the `env` attribute. For example, if
you have a local checkout of `random`, you can enter a development environment
for it like this (if the dependencies in the development and packaged version
match):

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
GHC invocation. In contrast, using `nix-shell -A haskellPackages.random` will
not result in an environment in which the dependencies are in GHCs package
database. Instead, the Haskell builder will pass in all dependencies explicitly
via configure flags.

`env` mirrors the normal derivation environment in one aspect: It does not include
familiar development tools like `cabal-install`, since we rely on plain `Setup.hs`
to build all packages. However, `cabal-install` will work as expected if in
`PATH` (e.g. when installed globally and using a `nix-shell` without `--pure`).
A declarative and pure way of adding arbitrary development tools is provided
via [`shellFor`](#haskell-shellFor).

When using `cabal-install` for dependency resolution you need to be a bit
careful to achieve build purity. `cabal-install` will find and use all
dependencies installed from the packages `env` via Nix, but it will also
consult Hackage to potentially download and compile dependencies if it can’t
find a valid build plan locally. To prevent this you can either never run
`cabal update`, remove the cabal database from your `~/.cabal` folder or run
`cabal` with `--offline`. Note though, that for some usecases `cabal2nix` needs
the local Hackage db.

Often you won't work on a package that is already part of `haskellPackages` or
Hackage, so we first need to write a Nix expression to obtain the development
environment from. Luckily, we can generate one very easily from an already
existing cabal file using `cabal2nix`:

```console
$ ls
my-project.cabal src …
$ cabal2nix ./. > my-project.nix
```

The generated Nix expression evaluates to a function ready to be
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

### shellFor {#haskell-shellFor}

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
environment. This means you can reuse Nix expressions of packages included in
nixpkgs, but also use local Nix expressions like this: `hpkgs: [
(hpkgs.callPackage ./my-project.nix { }) ]`.

`nativeBuildInputs`
: Expects a list of derivations to add as build tools to the build environment.
This is the place to add packages like `cabal-install`, `doctest` or `hlint`.
Defaults to `[]`.

`buildInputs`
: Expects a list of derivations to add as library dependencies, like `openssl`.
This is rarely necessary as the haskell package expressions usually track system
dependencies as well. Defaults to `[]`. (see also
[derivation dependencies](#haskell-derivation-deps))

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
    # call our generated Nix expression manually
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

### haskell-language-server {#haskell-language-server}

To use HLS in short: Install `pkgs.haskell-language-server` e.g. in
`nativeBuildInputs` in `shellFor` and use the `haskell-language-server-wrapper`
command to run it. See the [HLS user guide] on how to configure your text
editor to use HLS and how to test your setup.

HLS needs to be compiled with the GHC version of the project you use it
on.

``pkgs.haskell-language-server`` provides
``haskell-language-server-wrapper``, ``haskell-language-server``
and ``haskell-language-server-x.x.x``
binaries, where ``x.x.x`` is the GHC version for which it is compiled. By
default, it only includes binaries for the current GHC version, to reduce
closure size. The closure size is large, because HLS needs to be dynamically
linked to work reliably. You can override the list of supported GHC versions
with e.g.

```nix
pkgs.haskell-language-server.override { supportedGhcVersions = [ "90" "94" ]; }
```
Where all strings `version` are allowed such that
`haskell.packages.ghc${version}` is an existing package set.

When you run `haskell-language-server-wrapper` it will detect the GHC
version used by the project you are working on (by asking e.g. cabal or
stack) and pick the appropriate versioned binary from your path.

Be careful when installing HLS globally and using a pinned nixpkgs for a
Haskell project in a `nix-shell`. If the nixpkgs versions deviate to much
(e.g., use different `glibc` versions) the `haskell-language-server-?.?.?`
executable will try to detect these situations and refuse to start. It is
recommended to obtain HLS via `nix-shell` from the nixpkgs version pinned in
there instead.

The top level `pkgs.haskell-language-server` attribute is just a convenience
wrapper to make it possible to install HLS for multiple GHC versions at the
same time. If you know, that you only use one GHC version, e.g., in a project
specific `nix-shell` you can simply use
`pkgs.haskellPackages.haskell-language-server` or
`pkgs.haskell.packages.*.haskell-language-server` from the package set you use.

If you use `nix-shell` for your development environments remember to start your
editor in that environment. You may want to use something like `direnv` and/or an
editor plugin to achieve this.

## Overriding Haskell packages {#haskell-overriding-haskell-packages}

### Overriding a single package {#haskell-overriding-a-single-package}

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
from `haskell.lib.compose` is used. E.g., if you want to install a man page
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

#### `haskell.lib.compose` {#haskell-haskell.lib.compose}

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

##### Packaging Helpers {#haskell-packaging-helpers}

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

##### Development Helpers {#haskell-development-helpers}

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

##### Trivial Helpers {#haskell-trivial-helpers}

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

#### Library functions in the Haskell package sets {#haskell-package-set-lib-functions}

Some library functions depend on packages from the Haskell package sets. Thus they are
exposed from those instead of from `haskell.lib.compose` which can only access what is
passed directly to it. When using the functions below, make sure that you are obtaining them
from the same package set (`haskellPackages`, `haskell.packages.ghc944` etc.) as the packages
you are working with or – even better – from the `self`/`final` fix point of your overlay to
`haskellPackages`.

Note: Some functions like `shellFor` that are not intended for overriding per se, are omitted
in this section. <!-- TODO(@sternenseemann): note about ifd section -->

`cabalSdist { src, name ? ... }`
: Generates the Cabal sdist tarball for `src`, suitable for uploading to Hackage.
Contrary to `haskell.lib.compose.sdistTarball`, it uses `cabal-install` over `Setup.hs`,
so it is usually faster: No build dependencies need to be downloaded, and we can
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

## Contributing {#haskell-contributing}

### Fixing a broken package {#haskell-fixing-a-broken-package}

### Package set generation {#haskell-package-set-generation}

### Packaging a Haskell project

### Backporting {#haskell-backporting}

Backporting changes to a stable NixOS version in general is covered
in nixpkgs' `CONTRIBUTING.md` in general. In particular refer to the
[backporting policy](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md#criteria-for-backporting-changes)
to check if the change you have in mind may be backported.

This section focuses on how to backport a package update (e.g. a
bug fix or security release). Fixing a broken package works like
it does for the unstable branches.

-->

## F.A.Q. {#haskell-faq}

### Why is topic X not covered in this section? Why is section Y missing? {#haskell-why-not-covered}

We have been working on [moving the nixpkgs Haskell documentation back into the
nixpkgs manual](https://github.com/NixOS/nixpkgs/issues/121403). Since this
process has not been completed yet, you may find some topics missing here
covered in the old [haskell4nix docs](https://haskell4nix.readthedocs.io/).

If you feel any important topic is not documented at all, feel free to comment
on the issue linked above.

[Stackage]: https://www.stackage.org
[cabal-project-files]: https://cabal.readthedocs.io/en/latest/cabal-project.html
[cabal2nix]: https://github.com/nixos/cabal2nix
[cpphs]: https://Hackage.haskell.org/package/cpphs
[haddock-hoogle-option]: https://haskell-haddock.readthedocs.io/en/latest/invoking.html#cmdoption-hoogle
[haddock-hyperlinked-source-option]: https://haskell-haddock.readthedocs.io/en/latest/invoking.html#cmdoption-hyperlinked-source
[haddock]: https://www.haskell.org/haddock/
[haskell-program-coverage]: https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/profiling.html#observing-code-coverage
[haskell.nix]: https://input-output-hk.github.io/haskell.nix/index.html
[HLS user guide]: https://haskell-language-server.readthedocs.io/en/latest/configuration.html#configuring-your-editor
[hoogle]: https://wiki.haskell.org/Hoogle
[jailbreak-cabal]: https://github.com/NixOS/jailbreak-cabal/
[optparse-applicative-completions]: https://github.com/pcapriotti/optparse-applicative/blob/7726b63796aa5d0df82e926d467f039b78ca09e2/README.md#bash-zsh-and-fish-completions
[profiling-detail]: https://cabal.readthedocs.io/en/latest/cabal-project.html#cfg-field-profiling-detail
[profiling]: https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/profiling.html
[search.nixos.org]: https://search.nixos.org
