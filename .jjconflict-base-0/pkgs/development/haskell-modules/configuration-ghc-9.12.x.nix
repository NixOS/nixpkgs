{ pkgs, haskellLib }:

self: super:

let
  inherit (pkgs) lib;

  versionAtMost = a: b: lib.versionAtLeast b a;

  warnVersion =
    predicate: ver: pkg:
    let
      pname = pkg.pname;
    in
    lib.warnIf (predicate ver
      super.${pname}.version
    ) "override for haskell.packages.ghc912.${pname} may no longer be needed" pkg;

  warnAfterVersion = warnVersion lib.versionOlder;
  warnFromVersion = warnVersion versionAtMost;

in

with haskellLib;

{
  llvmPackages = lib.dontRecurseIntoAttrs self.ghc.llvmPackages;

  # Disable GHC core libraries
  array = null;
  base = null;
  binary = null;
  bytestring = null;
  Cabal = null;
  Cabal-syntax = null;
  containers = null;
  deepseq = null;
  directory = null;
  exceptions = null;
  file-io = null;
  filepath = null;
  ghc-bignum = null;
  ghc-boot = null;
  ghc-boot-th = null;
  ghc-compact = null;
  ghc-experimental = null;
  ghc-heap = null;
  ghc-internal = null;
  ghc-platform = null;
  ghc-prim = null;
  ghc-toolchain = null;
  ghci = null;
  haddock-api = null;
  haddock-library = null;
  haskeline = null;
  hpc = null;
  integer-gmp = null;
  mtl = null;
  os-string = null;
  parsec = null;
  pretty = null;
  process = null;
  rts = null;
  semaphore-compat = null;
  stm = null;
  system-cxx-std-lib = null;
  template-haskell = null;
  # GHC only builds terminfo if it is a native compiler
  terminfo =
    if pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform then
      null
    else
      haskellLib.doDistribute self.terminfo_0_4_1_7;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  #
  # Hand pick versions that are compatible with ghc 9.12 and base 4.21
  #

  extra = doDistribute self.extra_1_8;
  htree = doDistribute self.htree_0_2_0_0;
  tagged = doDistribute self.tagged_0_8_9;
  time-compat = doDistribute self.time-compat_1_9_8;
  extensions = doDistribute self.extensions_0_1_0_3;
  doctest = doDistribute self.doctest_0_24_0;
  ghc-syntax-highlighter = doDistribute self.ghc-syntax-highlighter_0_0_13_0;
  ghc-lib = doDistribute self.ghc-lib_9_12_2_20250320;
  ghc-exactprint = doDistribute self.ghc-exactprint_1_12_0_0;
  ghc-lib-parser = doDistribute self.ghc-lib-parser_9_12_2_20250320;
  ghc-lib-parser-ex = doDistribute self.ghc-lib-parser-ex_9_12_0_0;
  hlint = doDistribute self.hlint_3_10;
  fourmolu = doDistribute self.fourmolu_0_18_0_0;
  ormolu = doDistribute self.ormolu_0_8_0_0;
  apply-refact = doDistribute self.apply-refact_0_15_0_0;

  #
  # Jailbreaks
  #

  lucid = doJailbreak super.lucid; # base <4.21
  extensions_0_1_0_3 = doJailbreak super.extensions_0_1_0_3; # hedgehog >=1.0 && <1.5, hspec-hedgehog >=0.0.1 && <0.2
  hie-compat = doJailbreak super.hie-compat; # base <4.21
  hiedb = doJailbreak super.hiedb; # base >=4.12 && <4.21, ghc >=8.6 && <9.11
  ed25519 = doJailbreak super.ed25519; # https://github.com/thoughtpolice/hs-ed25519/issues/39
  ghc-trace-events = doJailbreak super.ghc-trace-events; # base <4.21
  time-compat_1_9_8 = doJailbreak super.time-compat_1_9_8; # too strict lower bound on QuickCheck
  cpphs = overrideCabal (drv: {
    # jail break manually the conditional dependencies
    postPatch = ''
      sed -i 's/time >=1.5 \&\& <1.13/time >=1.5 \&\& <=1.14/g' cpphs.cabal
    '';
  }) super.cpphs;
  vector = doJailbreak super.vector; # doctest >=0.15 && <0.24
  binary-instances = doJailbreak super.binary-instances; # base >=4.6.0.1 && <4.21, tagged >=0.8.8 && <0.8.9
  cabal-install-parsers = doJailbreak super.cabal-install-parsers; # base, Cabal-syntax, etc.
  http-api-data = doJailbreak super.http-api-data; # base < 4.21
  servant = doJailbreak super.servant; # base < 4.21
  ghc-exactprint_1_12_0_0 = addBuildDepends [
    # somehow buildDepends was missing
    self.Diff
    self.extra
    self.ghc-paths
    self.silently
    self.syb
    self.HUnit
  ] super.ghc-exactprint_1_12_0_0;
  co-log-core = doJailbreak super.co-log-core; # doctest >=0.16.0 && <0.24

  #
  # Test suite issues
  #

  call-stack = dontCheck super.call-stack; # https://github.com/sol/call-stack/issues/19

  relude = dontCheck super.relude;

  doctest_0_24_0 = overrideCabal (drv: {
    testFlags = drv.testFlags or [ ] ++ [
      # These tests require cabal-install (would cause infinite recursion)
      "--skip=/Cabal.Options"
      "--skip=/Cabal.Paths/paths"
      "--skip=/Cabal.ReplOptions" # >= 0.23
    ];
  }) super.doctest_0_24_0;

  # https://github.com/typeable/generic-arbitrary/issues/18
  generic-arbitrary = overrideCabal (drv: {
    patches = drv.patches or [ ] ++ [
      (pkgs.fetchpatch {
        name = "hellwolf:fix-recursive-test-hidding-unit";
        url = "https://github.com/typeable/generic-arbitrary/commit/133b80be93e6744f21e0e5ed4180a24c589f92e4.patch";
        sha256 = "sha256-z9EVcD1uNAYUOVTwmCCnrEFFOvFB7lD94Y6BwGVwVRQ=";
      })
    ];
  }) super.generic-arbitrary;

  # https://gitlab.haskell.org/ghc/ghc/-/issues/25930
  generic-lens = dontCheck super.generic-lens;

  # Cabal 3.14 regression (incorrect datadir in tests): https://github.com/haskell/cabal/issues/10717
  alex = overrideCabal (drv: {
    preCheck =
      drv.preCheck or ""
      + ''
        export alex_datadir="$(pwd)/data"
      '';
  }) super.alex;

  # https://github.com/sjakobi/newtype-generics/pull/28/files
  newtype-generics = warnAfterVersion "0.6.2" (doJailbreak super.newtype-generics);

  #
  # Multiple issues
  #

  fourmolu_0_18_0_0 = dontCheck (
    super.fourmolu_0_18_0_0.override {
      # Diff >=1 && <2
      Diff = super.Diff_1_0_2;
    }
  );

  doctest-parallel = overrideCabal (drv: {
    patches = drv.patches or [ ] ++ [
      (pkgs.fetchpatch {
        name = "doctest-0.23.0-ghc-9.12.patch";
        url = "https://github.com/martijnbastiaan/doctest-parallel/commit/d3df7aa5d223f3daeb676c8a7efe093ee743d54f.patch";
        sha256 = "sha256-92CtqBCulfOTjLAeC205cIrqL/2CBP1YFLijTVcTD2M=";
        includes = [ "src/Test/DocTest/Helpers.hs" ];
      })
    ];
  }) (dontCheck (doJailbreak super.doctest-parallel)); # Cabal >=2.4 && <3.13

  haskell-language-server = disableCabalFlag "retrie" (
    disableCabalFlag "stylishhaskel" (
      super.haskell-language-server.override {
        stylish-haskell = null;
        floskell = null;
        retrie = null;
      }
    )
  );
}
