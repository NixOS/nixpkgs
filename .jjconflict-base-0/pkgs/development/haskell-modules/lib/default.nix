# TODO(@Ericson2314): Remove `pkgs` param, which is only used for
# `buildStackProject`, `justStaticExecutables` and `checkUnusedPackages`
{ pkgs, lib }:

rec {
  /*
    The same functionality as this haskell.lib, except that the derivation
    being overridden is always the last parameter. This permits more natural
    composition of several overrides, i.e. without having to nestle one call
    between the function name and argument of another. haskell.lib.compose is
    preferred for any new code.
  */
  compose = import ./compose.nix { inherit pkgs lib; };

  /*
    This function takes a file like `hackage-packages.nix` and constructs
    a full package set out of that.
  */
  makePackageSet = compose.makePackageSet;

  /*
    The function overrideCabal lets you alter the arguments to the
    mkDerivation function.

    Example:

    First, note how the aeson package is constructed in hackage-packages.nix:

        "aeson" = callPackage ({ mkDerivation, attoparsec, <snip>
                               }:
                                 mkDerivation {
                                   pname = "aeson";
                                   <snip>
                                   homepage = "https://github.com/bos/aeson";
                                 })

    The mkDerivation function of haskellPackages will take care of putting
    the homepage in the right place, in meta.

        > haskellPackages.aeson.meta.homepage
        "https://github.com/bos/aeson"

        > x = haskell.lib.overrideCabal haskellPackages.aeson (old: { homepage = old.homepage + "#readme"; })
        > x.meta.homepage
        "https://github.com/bos/aeson#readme"
  */
  overrideCabal = drv: f: compose.overrideCabal f drv;

  # : Map Name (Either Path VersionNumber) -> HaskellPackageOverrideSet
  # Given a set whose values are either paths or version strings, produces
  # a package override set (i.e. (self: super: { etc. })) that sets
  # the packages named in the input set to the corresponding versions
  packageSourceOverrides = compose.packageSourceOverrides;

  /*
    doCoverage modifies a haskell package to enable the generation
    and installation of a coverage report.

    See https://wiki.haskell.org/Haskell_program_coverage
  */
  doCoverage = compose.doCoverage;

  /*
    dontCoverage modifies a haskell package to disable the generation
    and installation of a coverage report.
  */
  dontCoverage = compose.dontCoverage;

  /*
    doHaddock modifies a haskell package to enable the generation and
    installation of API documentation from code comments using the
    haddock tool.
  */
  doHaddock = compose.doHaddock;

  /*
    dontHaddock modifies a haskell package to disable the generation and
    installation of API documentation from code comments using the
    haddock tool.
  */
  dontHaddock = compose.dontHaddock;

  /*
    doJailbreak enables the removal of version bounds from the cabal
    file. You may want to avoid this function.

    This is useful when a package reports that it can not be built
    due to version mismatches. In some cases, removing the version
    bounds entirely is an easy way to make a package build, but at
    the risk of breaking software in non-obvious ways now or in the
    future.

    Instead of jailbreaking, you can patch the cabal file.

    Note that jailbreaking at this time, doesn't lift bounds on
    conditional branches.
    https://github.com/peti/jailbreak-cabal/issues/7 has further details.
  */
  doJailbreak = compose.doJailbreak;

  /*
    dontJailbreak restores the use of the version bounds the check
    the use of dependencies in the package description.
  */
  dontJailbreak = compose.dontJailbreak;

  /*
    doCheck enables dependency checking, compilation and execution
    of test suites listed in the package description file.
  */
  doCheck = compose.doCheck;
  /*
    dontCheck disables dependency checking, compilation and execution
    of test suites listed in the package description file.
  */
  dontCheck = compose.dontCheck;
  /*
    The dontCheckIf variant sets doCheck = false if the condition
    applies. In any other case the previously set/default value is used.
    This prevents accidentally re-enabling tests in a later override.
  */
  dontCheckIf = drv: condition: compose.dontCheckIf condition drv;

  /*
    doBenchmark enables dependency checking, compilation and execution
    for benchmarks listed in the package description file.
  */
  doBenchmark = compose.doBenchmark;
  /*
    dontBenchmark disables dependency checking, compilation and execution
    for benchmarks listed in the package description file.
  */
  dontBenchmark = compose.dontBenchmark;

  /*
    doDistribute enables the distribution of binaries for the package
    via hydra.
  */
  doDistribute = compose.doDistribute;
  /*
    dontDistribute disables the distribution of binaries for the package
    via hydra.
  */
  dontDistribute = compose.dontDistribute;

  /*
    appendConfigureFlag adds a single argument that will be passed to the
    cabal configure command, after the arguments that have been defined
    in the initial declaration or previous overrides.

    Example:

        > haskell.lib.appendConfigureFlag haskellPackages.servant "--profiling-detail=all-functions"
  */
  appendConfigureFlag = drv: x: compose.appendConfigureFlag x drv;
  appendConfigureFlags = drv: xs: compose.appendConfigureFlags xs drv;

  appendBuildFlag = drv: x: compose.appendBuildFlag x drv;
  appendBuildFlags = drv: xs: compose.appendBuildFlags xs drv;

  /*
    removeConfigureFlag drv x is a Haskell package like drv, but with
    all cabal configure arguments that are equal to x removed.

        > haskell.lib.removeConfigureFlag haskellPackages.servant "--verbose"
  */
  removeConfigureFlag = drv: x: compose.removeConfigureFlag x drv;

  addBuildTool = drv: x: compose.addBuildTool x drv;
  addBuildTools = drv: xs: compose.addBuildTools xs drv;

  addExtraLibrary = drv: x: compose.addExtraLibrary x drv;
  addExtraLibraries = drv: xs: compose.addExtraLibraries xs drv;

  addBuildDepend = drv: x: compose.addBuildDepend x drv;
  addBuildDepends = drv: xs: compose.addBuildDepends xs drv;

  addTestToolDepend = drv: x: compose.addTestToolDepend x drv;
  addTestToolDepends = drv: xs: compose.addTestToolDepends xs drv;

  addPkgconfigDepend = drv: x: compose.addPkgconfigDepend x drv;
  addPkgconfigDepends = drv: xs: compose.addPkgconfigDepends xs drv;

  addSetupDepend = drv: x: compose.addSetupDepend x drv;
  addSetupDepends = drv: xs: compose.addSetupDepends xs drv;

  enableCabalFlag = drv: x: compose.enableCabalFlag x drv;
  disableCabalFlag = drv: x: compose.disableCabalFlag x drv;

  markBroken = compose.markBroken;
  unmarkBroken = compose.unmarkBroken;
  markBrokenVersion = compose.markBrokenVersion;
  markUnbroken = compose.markUnbroken;

  disableParallelBuilding = compose.disableParallelBuilding;

  enableLibraryProfiling = compose.enableLibraryProfiling;
  disableLibraryProfiling = compose.disableLibraryProfiling;

  enableExecutableProfiling = compose.enableExecutableProfiling;
  disableExecutableProfiling = compose.disableExecutableProfiling;

  enableSharedExecutables = compose.enableSharedExecutables;
  disableSharedExecutables = compose.disableSharedExecutables;

  enableSharedLibraries = compose.enableSharedLibraries;
  disableSharedLibraries = compose.disableSharedLibraries;

  enableDeadCodeElimination = compose.enableDeadCodeElimination;
  disableDeadCodeElimination = compose.disableDeadCodeElimination;

  enableStaticLibraries = compose.enableStaticLibraries;
  disableStaticLibraries = compose.disableStaticLibraries;

  enableSeparateBinOutput = compose.enableSeparateBinOutput;

  appendPatch = drv: x: compose.appendPatch x drv;
  appendPatches = drv: xs: compose.appendPatches xs drv;

  /*
    Set a specific build target instead of compiling all targets in the package.
    For example, imagine we have a .cabal file with a library, and 2 executables "dev" and "server".
    We can build only "server" and not wait on the compilation of "dev" by using setBuildTarget as follows:

      setBuildTarget (callCabal2nix "thePackageName" thePackageSrc {}) "server"
  */
  setBuildTargets = drv: xs: compose.setBuildTargets xs drv;
  setBuildTarget = drv: x: compose.setBuildTarget x drv;

  doHyperlinkSource = compose.doHyperlinkSource;
  dontHyperlinkSource = compose.dontHyperlinkSource;

  disableHardening = drv: flags: compose.disableHardening flags drv;

  /*
    Let Nix strip the binary files.
    This removes debugging symbols.
  */
  doStrip = compose.doStrip;

  /*
    Stop Nix from stripping the binary files.
    This keeps debugging symbols.
  */
  dontStrip = compose.dontStrip;

  /*
    Useful for debugging segfaults with gdb.
    This includes dontStrip.
  */
  enableDWARFDebugging = compose.enableDWARFDebugging;

  /*
    Create a source distribution tarball like those found on hackage,
    instead of building the package.
  */
  sdistTarball = compose.sdistTarball;

  /*
    Create a documentation tarball suitable for uploading to Hackage instead
    of building the package.
  */
  documentationTarball = compose.documentationTarball;

  /*
    Use the gold linker. It is a linker for ELF that is designed
    "to run as fast as possible on modern systems"
  */
  linkWithGold = compose.linkWithGold;

  /*
    link executables statically against haskell libs to reduce
    closure size
  */
  justStaticExecutables = compose.justStaticExecutables;

  /*
    Build a source distribution tarball instead of using the source files
    directly. The effect is that the package is built as if it were published
    on hackage. This can be used as a test for the source distribution,
    assuming the build fails when packaging mistakes are in the cabal file.
  */
  buildFromSdist = compose.buildFromSdist;

  /*
    Build the package in a strict way to uncover potential problems.
    This includes buildFromSdist and failOnAllWarnings.
  */
  buildStrictly = compose.buildStrictly;

  # Disable core optimizations, significantly speeds up build time
  disableOptimization = compose.disableOptimization;

  /*
    Turn on most of the compiler warnings and fail the build if any
    of them occur.
  */
  failOnAllWarnings = compose.failOnAllWarnings;

  /*
    Add a post-build check to verify that dependencies declared in
    the cabal file are actually used.

    The first attrset argument can be used to configure the strictness
    of this check and a list of ignored package names that would otherwise
    cause false alarms.
  */
  checkUnusedPackages = compose.checkUnusedPackages;

  buildStackProject = compose.buildStackProject;

  /*
    Add a dummy command to trigger a build despite an equivalent
    earlier build that is present in the store or cache.
  */
  triggerRebuild = drv: i: compose.triggerRebuild i drv;

  /*
    Override the sources for the package and optionally the version.
    This also takes of removing editedCabalFile.
  */
  overrideSrc = drv: src: compose.overrideSrc src drv;

  # Get all of the build inputs of a haskell package, divided by category.
  getBuildInputs = compose.getBuildInputs;

  # Extract the haskell build inputs of a haskell package.
  # This is useful to build environments for developing on that
  # package.
  getHaskellBuildInputs = compose.getHaskellBuildInputs;

  # Under normal evaluation, simply return the original package. Under
  # nix-shell evaluation, return a nix-shell optimized environment.
  shellAware = compose.shellAware;

  ghcInfo = compose.ghcInfo;

  ### mkDerivation helpers
  # These allow external users of a haskell package to extract
  # information about how it is built in the same way that the
  # generic haskell builder does, by reusing the same functions.
  # Each function here has the same interface as mkDerivation and thus
  # can be called for a given package simply by overriding the
  # mkDerivation argument it used. See getHaskellBuildInputs above for
  # an example of this.

  # Some information about which phases should be run.
  controlPhases = compose.controlPhases;

  # Utility to convert a directory full of `cabal2nix`-generated files into a
  # package override set
  #
  # packagesFromDirectory : { directory : Directory, ... } -> HaskellPackageOverrideSet
  packagesFromDirectory = compose.packagesFromDirectory;

  addOptparseApplicativeCompletionScripts =
    exeName: pkg:
    lib.warn "addOptparseApplicativeCompletionScripts is deprecated in favor of haskellPackages.generateOptparseApplicativeCompletions. Please change ${pkg.name} to use the latter and make sure it uses its matching haskell.packages set!" (
      compose.__generateOptparseApplicativeCompletion exeName pkg
    );

  /*
    Modify a Haskell package to add shell completion scripts for the
    given executable produced by it. These completion scripts will be
    picked up automatically if the resulting derivation is installed,
    e.g. by `nix-env -i`.

    Invocation:
      generateOptparseApplicativeCompletions command pkg

      command: name of an executable
          pkg: Haskell package that builds the executables
  */
  generateOptparseApplicativeCompletion = compose.generateOptparseApplicativeCompletion;

  /*
    Modify a Haskell package to add shell completion scripts for the
    given executables produced by it. These completion scripts will be
    picked up automatically if the resulting derivation is installed,
    e.g. by `nix-env -i`.

    Invocation:
      generateOptparseApplicativeCompletions commands pkg

     commands: name of an executable
          pkg: Haskell package that builds the executables
  */
  generateOptparseApplicativeCompletions = compose.generateOptparseApplicativeCompletions;

  # Don't fail at configure time if there are multiple versions of the
  # same package in the (recursive) dependencies of the package being
  # built. Will delay failures, if any, to compile time.
  allowInconsistentDependencies = compose.allowInconsistentDependencies;
}
