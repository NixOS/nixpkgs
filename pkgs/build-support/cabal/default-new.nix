# generic builder for Cabal packages
{ stdenv, fetchurl, lib, pkgconfig, haskellCompiler, Cabal, jailbreakCabal, glibcLocales
, gnugrep, coreutils, hscolour
, enableLibraryProfiling ? false
, enableSharedLibraries ? false
, enableSharedExecutables ? false
, enableStaticLibraries ? true
, enableCheckPhase ? ((haskellCompiler.compilerName == "ghc") && (stdenv.lib.versionOlder "7.4" haskellCompiler.compilerVersion))
, enableHyperlinkSource ? true
, extension ? (self : super : {})
}:

let
  enableFeature         = stdenv.lib.enableFeature;
  versionOlder          = stdenv.lib.versionOlder;
  optional              = stdenv.lib.optional;
  optionals             = stdenv.lib.optionals;
  optionalString        = stdenv.lib.optionalString;
  filter                = stdenv.lib.filter;

  defaultSetupHs        = builtins.toFile "Setup.hs" ''
                            import Distribution.Simple
                            main = defaultMain
                          '';
in

let
  # prepare callPackage with all alltributes defined above for importing the Haskell compiler specific build scripts
  callBuildScript = lib.callPackageWith {inherit stdenv fetchurl lib pkgconfig haskellCompiler Cabal
                                                 jailbreakCabal glibcLocales gnugrep coreutils hscolour
                                                 enableLibraryProfiling enableSharedLibraries
                                                 enableSharedExecutables enableStaticLibraries enableCheckPhase
                                                 enableHyperlinkSource enableFeature versionOlder optional
                                                 optionals optionalString filter defaultSetupHs;};
in


# Cabal shipped with GHC 6.12.4 or earlier doesn't know the "--enable-tests configure" flag.
assert enableCheckPhase -> ((haskellCompiler.compilerName == "ghc") && (versionOlder "7" haskellCompiler.compilerVersion));

# GHC prior to 7.4.x doesn't know the "--enable-executable-dynamic" flag.
assert enableSharedExecutables -> ((haskellCompiler.compilerName == "ghc") && (versionOlder "7.4" haskellCompiler.compilerVersion));

# Our GHC 6.10.x builds do not provide sharable versions of their core libraries.
assert enableSharedLibraries -> ((haskellCompiler.compilerName == "ghc") && (versionOlder "6.12" haskellCompiler.compilerVersion));

# Pure shared library builds don't work before GHC 7.8.x.
assert !enableStaticLibraries -> ((haskellCompiler.compilerName == "ghc") && (versionOlder "7.7" haskellCompiler.compilerVersion));

{
  mkDerivation =
    args : # arguments for the individual package, can modify the defaults
    let # These attributes are removed in the end. This is in order not to spoil the build
        # environment overly, but also to keep hash-backwards-compatible with the old cabal.nix.
        internalAttrs = [
          "internalAttrs" "buildDepends" "buildTools" "extraLibraries" "pkgconfigDepends"
          "isLibrary" "isExecutable" "testDepends"
        ];

        # Compare compiler and its version againts the black- and whitelists of the package
        passBWList = compiler: version: blacklist: whitelist:
          if (((builtins.elem compiler blacklist) || (builtins.elem (compiler+"-"+version) blacklist))
             && !((builtins.elem compiler whitelist) || (builtins.elem (compiler+"-"+version) whitelist)))
          then false else true;

        # Stuff happening after the user preferences have been processed. We remove
        # internal attributes and strip null elements from the dependency lists, all
        # in the interest of keeping hashes stable.
        postprocess =
          x : if passBWList haskellCompiler.compilerName haskellCompiler.compilerVersion x.compilerBlacklist x.compilerWhitelist
              then
                (removeAttrs x internalAttrs) // {
                  buildInputs           = filter (y : ! (y == null)) x.buildInputs;
                  propagatedBuildInputs = filter (y : ! (y == null)) x.propagatedBuildInputs;
                  propagatedUserEnvPkgs = filter (y : ! (y == null)) x.propagatedUserEnvPkgs;
                  doCheck               = enableCheckPhase && x.doCheck;
                  hyperlinkSource       = enableHyperlinkSource && x.hyperlinkSource;
                }
              else
                null;


        defaults =
          self : { # self is the final version of the attribute set

            # pname should be defined by the client to be the package basename
            # version should be defined by the client to be the package version

            # fname is the internal full name of the package
            fname = "${self.pname}-${self.version}";

            # name is the external full name of the package; usually we prefix
            # all packages with haskell- to avoid name clashes for libraries;
            # if that is not desired (for applications), name can be set to
            # fname.
            name = if self.isLibrary then
                     if enableLibraryProfiling && self.enableSharedLibraries then
                       "haskell-${self.pname}-${haskellCompiler.compilerName}${haskellCompiler.compilerVersion}-${self.version}-profiling-shared"
                     else if enableLibraryProfiling && !self.enableSharedLibraries then
                       "haskell-${self.pname}-${haskellCompiler.compilerName}${haskellCompiler.compilerVersion}-${self.version}-profiling"
                     else if !enableLibraryProfiling && self.enableSharedLibraries then
                       "haskell-${self.pname}-${haskellCompiler.compilerName}${haskellCompiler.compilerVersion}-${self.version}-shared"
                     else
                       "haskell-${self.pname}-${haskellCompiler.compilerName}${haskellCompiler.compilerVersion}-${self.version}"
                   else
                     "${self.pname}-${self.version}";

            # the default download location for Cabal packages is Hackage,
            # you still have to specify the checksum
            src = fetchurl {
              url = "mirror://hackage/${self.pname}/${self.fname}.tar.gz";
              inherit (self) sha256;
            };

            # default buildInputs are just ghc, if more buildInputs are required
            # buildInputs can be extended by the client by using extraBuildInputs,
            # but often propagatedBuildInputs is preferable anyway
            buildInputs = [haskellCompiler Cabal] ++ self.extraBuildInputs;
            extraBuildInputs = self.buildTools ++
                               (optionals self.doCheck self.testDepends) ++
                               (optional self.hyperlinkSource hscolour) ++
                               (if self.pkgconfigDepends == [] then [] else [pkgconfig]) ++
                               (if self.isLibrary then [] else self.buildDepends ++ self.extraLibraries ++ self.pkgconfigDepends);

            # we make sure that propagatedBuildInputs is defined, so that we don't
            # have to check for its existence
            propagatedBuildInputs = if self.isLibrary then self.buildDepends ++ self.extraLibraries ++ self.pkgconfigDepends else [];

            # By default, also propagate all dependencies to the user environment. This is required, otherwise packages would be broken, because
            # GHC also needs all dependencies to be available.
            propagatedUserEnvPkgs = if self.isLibrary then self.buildDepends else [];

            # library directories that have to be added to the Cabal files
            extraLibDirs = [];

            # build-depends Cabal field
            buildDepends = [];

            # target(s) passed to the cabal build phase as an argument
            buildTarget = "";

            # build-depends Cabal fields stated in test-suite stanzas
            testDepends = [];

            # target(s) passed to the cabal test phase as an argument
            testTarget = "";

            # build-tools Cabal field
            buildTools = [];

            # extra-libraries Cabal field
            extraLibraries = [];

            # pkgconfig-depends Cabal field
            pkgconfigDepends = [];

            isLibrary = ! self.isExecutable;
            isExecutable = false;
            # wrap executables with GHC environment variables
            # that seems useful when using ghc-paths, which is specially patched for Nix
            wrapExecutables = false;

            # ignore version restrictions on the build inputs that the cabal file might specify
            jailbreak = false;

            # pass the '--enable-split-objs' flag to cabal in the configure stage
            enableSplitObjs = !stdenv.isDarwin;         # http://hackage.haskell.org/trac/ghc/ticket/4013

            # pass the '--enable-tests' flag to cabal in the configure stage
            # and run any regression test suites the package might have
            doCheck = enableCheckPhase;

            # pass the '--hyperlink-source' flag to ./Setup haddock
            hyperlinkSource = enableHyperlinkSource;

            # abort the build if the configure phase detects that the package
            # depends on multiple versions of the same build input
            strictConfigurePhase = true;

            # Enable or disable the package for a particular compiler.
            # The whitelist takes precedence over the blacklist.
            # The compiler are matched by name, and by version, if given.
            # E.g. "ghc-7.8.3" for a particular version of ghc, or "haste"
            # for all versions of haste.
            compilerWhitelist = [];
            compilerBlacklist = ["haste"];

            # pass the '--enable-library-vanilla' flag to cabal in the
            # configure stage to enable building shared libraries
            inherit enableStaticLibraries;

            # pass the '--enable-shared' flag to cabal in the configure
            # stage to enable building shared libraries
            inherit enableSharedLibraries;

            # pass the '--enable-executable-dynamic' flag to cabal in
            # the configure stage to enable linking shared libraries
            inherit enableSharedExecutables;

            extraConfigureFlags = [
              (enableFeature self.enableSplitObjs "split-objs")
              (enableFeature enableLibraryProfiling "library-profiling")
              (enableFeature self.enableSharedLibraries "shared")
              (optional ((haskellCompiler.compilerName == "ghc") && (versionOlder "7" haskellCompiler.compilerVersion))
                (enableFeature self.enableStaticLibraries "library-vanilla"))
              (optional ((haskellCompiler.compilerName == "ghc") && (versionOlder "7.4" haskellCompiler.compilerVersion))
                (enableFeature self.enableSharedExecutables "executable-dynamic"))
              (optional ((haskellCompiler.compilerName == "ghc") && (versionOlder "7" haskellCompiler.compilerVersion))
                (enableFeature self.doCheck "tests"))
            ];

            # GHC needs the locale configured during the Haddock phase.
            LANG = "en_US.UTF-8";
            LOCALE_ARCHIVE = optionalString stdenv.isLinux "${glibcLocales}/lib/locale/locale-archive";

            # include compiler specific configurePhase, buildPhase, checkPhase and installPhase.
            inherit (callBuildScript haskellCompiler.compilerCabalBuildScripts {self=self;}) configurePhase buildPhase checkPhase installPhase;

            # We inherit stdenv and ghc so that they can be used in Cabal derivations.
            # "ghc" is the lecacy name in the Cabal package definitions.
            inherit stdenv;
            ghc = haskellCompiler;
          };

      # generate the content for mkDerivation, or null if package can not be build
      derivationContent = postprocess (let super = defaults self // args self;

                                           self  = super // extension self super;
                                       in self);
    in
      if isNull derivationContent then null else stdenv.mkDerivation derivationContent;
}
