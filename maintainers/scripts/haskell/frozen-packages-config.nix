{ pkgs ? import ../../../default.nix {} }:

let
  inherit (pkgs) lib;

  emptyOverlay = self: super: {};
  emptyConfig = { ... }: emptyOverlay;

  # Create a haskell package set with basically no configuration overlays applied.
  # This is not intended to be built, but only to be used for evaluation
  # introspection in order to obtain a list of versions that is as close as
  # possible to hackage-packages.nix (with out having to reimplement the fix
  # point logic required to import that package).
  #
  # To achieve this we import the haskell package set with an arbitrary build
  # package set and compiler, but instead of the configuration-*.nix files,
  # we pass empty overlays (see above) and a compilerConfig which sets the
  # packages bundled with GHC to `null` as required for evaluation.
  #
  # This achieves a haskell package set where every package's version is the same
  # as defined in hackage-packages.nix, since it can't be altered in any
  # configuration-*.nix file. Additionally non-hackage-packages.nix is skipped,
  # since we are only interested in generating constraints for packages on hackage.
  vanillaPackageSet = pkgs.callPackage ../../../pkgs/development/haskell-modules {
    haskellLib = pkgs.haskell.lib;
    buildHaskellPackages = pkgs.buildPackages.haskell.packages.ghc8104;
    ghc = pkgs.haskell.compiler.ghc8104;

    compilerConfig = self: super: {
      array = null;
      base = null;
      binary = null;
      bytestring = null;
      Cabal = null;
      containers = null;
      deepseq = null;
      directory = null;
      exceptions = null;
      filepath = null;
      ghc-boot = null;
      ghc-boot-th = null;
      ghc-compact = null;
      ghc-heap = null;
      ghc-prim = null;
      ghci = null;
      haskeline = null;
      hpc = null;
      integer-gmp = null;
      libiserv = null;
      mtl = null;
      parsec = null;
      pretty = null;
      process = null;
      rts = null;
      stm = null;
      template-haskell = null;
      terminfo = null;
      text = null;
      time = null;
      transformers = null;
      unix = null;
      xhtml = null;

      ghcjs-base = null;
    };

    nonHackagePackages = emptyOverlay;
    configurationCommon = emptyConfig;
    configurationNix = emptyConfig;
    configurationArm = emptyConfig;
    configurationDarwin = emptyConfig;
  };

  # Simple predicate which checks if something looks like a derivation which
  # builds a package from hackage. This is used to distinguish hackage packages
  # from other package sets and GHC in the haskell package set.
  isHackage = pkg: pkg ? src.urls &&
    builtins.any (lib.hasPrefix "mirror://hackage") pkg.src.urls;

  # Creates a cabal version constraint for a given package name and derivation,
  # pinning it to its current version.
  makeConstraint = name: pkg: "${name} == ${pkg.version}";

  # Evaluates to a list of package constraints pinning all packages in
  # vanillaPackageSet to their current version.
  constraintsForCurrentVersions =
    lib.mapAttrsToList makeConstraint (
      lib.filterAttrs (
        name: pkg: !(lib.hasInfix "_" name) && pkg ? version && isHackage pkg
      ) vanillaPackageSet
    );

  # constraintsForCurrentVersions as a YAML configuration suitable to be
  # passed to hackage2nix.
  hackage2nixConfig = ''
    default-package-overrides:
  '' + lib.concatMapStrings (constraint: ''
    - ${constraint}
  '') constraintsForCurrentVersions;
in

pkgs.writeText "frozen-packages.yaml" hackage2nixConfig

