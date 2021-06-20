# Haskell {#sec-haskell}

The Haskell infrastructure in nixpkgs has two main purposes: The
primary purpose is to provide a Haskell compiler and build tools
as well as infrastructure for packaging Haskell-based packages.

The secondary purpose is to provide support for Haskell development
environment including prebuilt Haskell libraries. However, in this
area sacrifices have been made due to self-imposed restrictions in
nixpkgs, to lessen the maintenance effort and improve performance.
Therefore it may be advantageous to use an alternative to the
Haskell infrastructure in nixpkgs for development environments in
many cases. The main limitations are that we only provide first-class
support for the default compiler (currently GHC 8.10.4) and usually
only provide a default and (if different) the latest version of
a haskell package.

## Available packages {#sec-haskell-available-packages}

The compiler and most build tools are exposed at the top level:

* `ghc` is the default version of GHC
* Language specific tools: `cabal-install`, `stack`, `hpack`, `alex`, `happy`, …

Many “normal” user facing packages written in Haskell, like `niv` or
`cachix`, are also exposed at the top level, so there is nothing
haskell specific to installing and using them.

All of these packages originally live in the `haskellPackages` package
set and are re-exposed with a reduced dependency closure for
convenience.

The `haskellPackages` set includes at least one version of every package
from hackage as well as some manually injected packages. This amounts to
a lot of packages, so it is hidden from `nix-env -qa` by default for
performance reasons. You can still list all packages in the set like
this, though:

```console
$ nix-env -f "<nixpkgs>" -qaP -A haskellPackages
haskellPackages.a50                                                         a50-0.5
haskellPackages.AAI                                                         AAI-0.2.0.1
haskellPackages.abacate                                                     abacate-0.0.0.0
haskellPackages.abc-puzzle                                                  abc-puzzle-0.2.1
haskellPackages.abcBridge                                                   abcBridge-0.15
…
```

The attribute names in `haskellPackages` always correspond with their
name on hackage. Since hackage allows names that are not valid nix
without extra escaping, you sometimes need to extra care when handling
attribute names like `3dmodels`.

For packages that are part of stackage, we use the version that is
currently part of [Stackage Nightly](https://www.stackage.org/nightly)
as the default version. For all other packages we use the latest
version from Hackage. Sometimes alternative versions of packages
are provided whose attribute names are their normal name with
their version appended after an underscore, e. g. `Cabal_3_4_0_0`.
If you are interested in details how the package set is populated,
read the section [Package set generation](#sec-haskell-package-set-generation).

Most of the packages contained in `haskellPackages` don't actually
build and are marked as broken semi-automatically. Most of those
packages are deprecated or unmaintained, but sometimes packages
that should, don't build. Very often fixing them is not a lot of
work. How you can help with that is described in [Fixing a broken
package](#sec-haskell-fixing-a-broken-package).

`haskellPackages` is built with our default compiler, but we also
provide other releases of GHC and package sets built with them.
You can list all available compilers like this:

```console
$ nix-env -f "<nixpkgs>" -qaP -A haskell.compiler
haskell.compiler.ghc8102Binary           ghc-8.10.2-binary
haskell.compiler.ghc8102BinaryMinimal    ghc-8.10.2-binary
haskell.compiler.ghc8104                 ghc-8.10.4
haskell.compiler.integer-simple.ghc8104  ghc-8.10.4
haskell.compiler.ghc865Binary            ghc-8.6.5-binary
haskell.compiler.ghc884                  ghc-8.8.4
haskell.compiler.integer-simple.ghc884   ghc-8.8.4
haskell.compiler.ghc901                  ghc-9.0.1
haskell.compiler.integer-simple.ghc901   ghc-9.0.1
haskell.compiler.ghcHEAD                 ghc-9.3.20210504
haskell.compiler.native-bignum.ghcHEAD   ghc-9.3.20210504
```

Every of those compilers has a corresponding attribute set built
completely using it. However, the non-standard package sets are
not tested regularly and have less working packages as a result.
The corresponding package set for GHC 9.0.1 is `haskell.packages.ghc901`
(in fact `haskellPackages` is just an alias for `haskell.packages.ghc8104`):

```console
$ nix-env -f "<nixpkgs>" -qaP -A haskell.packages.ghc901
haskell.packages.ghc901.a50                                                         a50-0.5
haskell.packages.ghc901.AAI                                                         AAI-0.2.0.1
haskell.packages.ghc901.abacate                                                     abacate-0.0.0.0
haskell.packages.ghc901.abc-puzzle                                                  abc-puzzle-0.2.1
haskell.packages.ghc901.abcBridge                                                   abcBridge-0.15
```

Every package set also re-exposes its GHC as `haskell.packages.*.ghc`.

## `haskellPackages.mkDerivation`

Every haskell package set has its own haskell-aware `mkDerivation` which
is used to build its packages. Generally you won't have to interact with
this builder since [cabal2nix](https://github.com/nixos/cabal2nix) can
generate packages using it for an arbitrary cabal package definition.
Still it is useful to know the parameters it takes when you need to
[override](#sec-haskell-overriding-haskell-packages) a generated nix expression.

`haskellPackages.mkDerivation` is a wrapper around `stdenv.mkDerivation`
which re-defines the default phases to be haskell aware and handles
dependency specification, test suites, benchmarks etc. by compiling
and invoking the package's `Setup.hs`. It does *not* use or invoke
the `cabal-install` binary, but uses the underlying `Cabal` library
instead.

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

`doCheck`
: Whether to execute the package's test suite if it has one. Defaults to `true` unless cross-compiling.

`doBenchmark`
: Whether to execute the package's benchmark if it has one. Defaults to `false`.

`doHoogle`
: Whether to generate a index file for [hoogle](https://wiki.haskell.org/Hoogle)
  as part of `haddockPhase` by passing the
  [--hoogle option](https://haskell-haddock.readthedocs.io/en/latest/invoking.html#cmdoption-hoogle).
  Defaults to `true`.

`doHaddockQuickjump`
: Whether to generate an index for interactive navigation of the HTML documentation.
  Defaults to `true` if supported.

`enableLibraryProfiling`
: Whether to enable [profiling](https://downloads.haskell.org/~ghc/8.10.4/docs/html/users_guide/profiling.html)
  for libraries contained in the package. Enabled by default if supported.

`enableExecutableProfiling`
: Whether to enable [profiling](https://downloads.haskell.org/~ghc/8.10.4/docs/html/users_guide/profiling.html)
  for executables contained in the package. Disabled by default.

`profilingDetail`
: [Profiling detail level](https://cabal.readthedocs.io/en/latest/cabal-project.html#cfg-field-profiling-detail)
  to set. Defaults to `exported-functions`.

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
  by passing [--hyperlinked-source](https://haskell-haddock.readthedocs.io/en/latest/invoking.html#cmdoption-hyperlinked-source).
  Defaults to `true`.

`isExecutable`
: Whether the package contains an executable.

`isLibrary`
: Whether the package contains a library.

`jailbreak`
: Whether to execute [jailbreak-cabal](https://github.com/peti/jailbreak-cabal/)
  before `configurePhase` to lift any version version constraints in the cabal file.
  Note that this can't lift version bounds if they are conditional, e. g. if a
  dependency is hidden behind a flag.

`enableParallelBuilding`
: Whether to use the `-j` flag to start multiple GHC jobs in parallel.

`maxBuildCores`
: Upper limit of jobs to use in parallel for compilation regardless of `$NIX_BUILD_CORES`.
  Defaults to 16 as haskell compilation with GHC currently sees a performance regression
  if too many parallel jobs are used.

`doCoverage`
: Whether to generate and install files needed for
  [HPC](https://downloads.haskell.org/~ghc/8.10.4/docs/html/users_guide/profiling.html#observing-code-coverage).
  Defaults to `false`.

`doHaddock`
: Wether to build (HTML) documentation using [haddock](https://www.haskell.org/haddock/).
  Defaults to `true` if supported.

`testTarget`
: Name of the test suite to build and run. If unset, all test suite will be executed.

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
: Whether to enable the [cpphs](https://archives.haskell.org/projects.haskell.org/cpphs/)
  preprocessor. Defaults to `false`.

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

Since `haskellPackages.mkDerivation` is intended to be generated from cabal files,
it reflects cabal's way of specifying dependencies. For one, dependencies are
grouped by what part of the package they belong to. This helps reducing the
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

The other categorization relates to the way the package depends on
the dependency:

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

Using these two distinctions, you should be able to categorize most of
the dependency specifications that are available:
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

`haskellPackages.mkDerivation` accepts the following attributes as
direct arguments which are transparently set in `meta` of the resulting
derivation. See the [Meta-attributes section](#chap-meta) for their
documentation.

* These attributes are populated with a default value if omitted:
    * `homepage`: defaults to the hackage page for `pname`.
    * `platforms`: defaults to `lib.platforms.all` (since GHC can cross-compile)
* These attributes are only passed if given:
    * `description`
    * `license`
    * `changelog`
    * `maintainers`
    * `broken`
    * `hydraPlatforms`

## Overriding haskell packages {#sec-haskell-overriding-haskell-packages}

## Contributing {#sec-haskell-contributing}

### Fixing a broken package {#sec-haskell-fixing-a-broken-package}

### Package set generation {#sec-haskell-package-set-generation}
