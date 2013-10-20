# generic builder for Cabal packages

{ stdenv, fetchurl, lib, pkgconfig, ghc, Cabal, jailbreakCabal, glibcLocales
, enableLibraryProfiling ? false
, enableSharedLibraries ? false
, enableSharedExecutables ? false
, enableCheckPhase ? stdenv.lib.versionOlder "7.4" ghc.version
}:

let
  enableFeature         = stdenv.lib.enableFeature;
  versionOlder          = stdenv.lib.versionOlder;
  optional              = stdenv.lib.optional;
  optionals             = stdenv.lib.optionals;
  optionalString        = stdenv.lib.optionalString;
  filter                = stdenv.lib.filter;
in

# Cabal shipped with GHC 6.12.4 or earlier doesn't know the "--enable-tests configure" flag.
assert enableCheckPhase -> versionOlder "7" ghc.version;

# GHC prior to 7.4.x doesn't know the "--enable-executable-dynamic" flag.
assert enableSharedExecutables -> versionOlder "7.4" ghc.version;

# Our GHC 6.10.x builds do not provide sharable versions of their core libraries.
assert enableSharedLibraries -> versionOlder "6.12" ghc.version;

{
  mkDerivation =
    args : # arguments for the individual package, can modify the defaults
    let # These attributes are removed in the end. This is in order not to spoil the build
        # environment overly, but also to keep hash-backwards-compatible with the old cabal.nix.
        internalAttrs = [
          "internalAttrs" "buildDepends" "buildTools" "extraLibraries" "pkgconfigDepends"
          "isLibrary" "isExecutable" "testDepends"
        ];

        # Stuff happening after the user preferences have been processed. We remove
        # internal attributes and strip null elements from the dependency lists, all
        # in the interest of keeping hashes stable.
        postprocess =
          x : (removeAttrs x internalAttrs) // {
                buildInputs           = filter (y : ! (y == null)) x.buildInputs;
                propagatedBuildInputs = filter (y : ! (y == null)) x.propagatedBuildInputs;
                doCheck               = enableCheckPhase && x.doCheck;
              };

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
                       "haskell-${self.pname}-ghc${ghc.ghc.version}-${self.version}-profiling-shared"
                     else if enableLibraryProfiling && !self.enableSharedLibraries then
                       "haskell-${self.pname}-ghc${ghc.ghc.version}-${self.version}-profiling"
                     else if !enableLibraryProfiling && self.enableSharedLibraries then
                       "haskell-${self.pname}-ghc${ghc.ghc.version}-${self.version}-shared"
                     else
                       "haskell-${self.pname}-ghc${ghc.ghc.version}-${self.version}"
                   else
                     "${self.pname}-${self.version}";

            # the default download location for Cabal packages is Hackage,
            # you still have to specify the checksum
            src = fetchurl {
              # cannot use mirrors system because of subtly different directory structures
              urls = ["http://hackage.haskell.org/packages/archive/${self.pname}/${self.version}/${self.fname}.tar.gz"
                      "http://hdiff.luite.com/packages/archive/${self.pname}/${self.fname}.tar.gz"];
              inherit (self) sha256;
            };

            # default buildInputs are just ghc, if more buildInputs are required
            # buildInputs can be extended by the client by using extraBuildInputs,
            # but often propagatedBuildInputs is preferable anyway
            buildInputs = [ghc Cabal] ++ self.extraBuildInputs;
            extraBuildInputs = self.buildTools ++
                               (optionals self.doCheck self.testDepends) ++
                               (if self.pkgconfigDepends == [] then [] else [pkgconfig]) ++
                               (if self.isLibrary then [] else self.buildDepends ++ self.extraLibraries ++ self.pkgconfigDepends);

            # we make sure that propagatedBuildInputs is defined, so that we don't
            # have to check for its existence
            propagatedBuildInputs = if self.isLibrary then self.buildDepends ++ self.extraLibraries ++ self.pkgconfigDepends else [];

            # library directories that have to be added to the Cabal files
            extraLibDirs = [];

            # build-depends Cabal field
            buildDepends = [];

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

            # ignore version restrictions on the build inputs that the cabal file might specify
            jailbreak = false;

            # pass the '--enable-split-objs' flag to cabal in the configure stage
            enableSplitObjs = !(  stdenv.isDarwin                       # http://hackage.haskell.org/trac/ghc/ticket/4013
                               || versionOlder "7.6.99" ghc.version     # -fsplit-ojbs is broken in 7.7 snapshot
                               );

            # pass the '--enable-tests' flag to cabal in the configure stage
            # and run any regression test suites the package might have
            doCheck = enableCheckPhase;

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
              (optional (versionOlder "7.4" ghc.version) (enableFeature self.enableSharedExecutables "executable-dynamic"))
              (optional (versionOlder "7" ghc.version) (enableFeature self.doCheck "tests"))
            ];

            # GHC needs the locale configured during the Haddock phase.
            LANG = "en_US.UTF-8";
            LOCALE_ARCHIVE = optionalString stdenv.isLinux "${glibcLocales}/lib/locale/locale-archive";

            # compiles Setup and configures
            configurePhase = ''
              eval "$preConfigure"

              ${optionalString self.jailbreak "${jailbreakCabal}/bin/jailbreak-cabal ${self.pname}.cabal"}

              for i in Setup.hs Setup.lhs; do
                test -f $i && ghc --make $i
              done

              for p in $extraBuildInputs $propagatedNativeBuildInputs; do
                if [ -d "$p/lib/ghc-${ghc.ghc.version}/package.conf.d" ]; then
                  # Haskell packages don't need any extra configuration.
                  continue;
                fi
                if [ -d "$p/include" ]; then
                  extraConfigureFlags+=" --extra-include-dirs=$p/include"
                fi
                for d in lib{,64}; do
                  if [ -d "$p/$d" ]; then
                    extraConfigureFlags+=" --extra-lib-dirs=$p/$d"
                  fi
                done
              done

              echo "configure flags: $extraConfigureFlags $configureFlags"
              ./Setup configure --verbose --prefix="$out" --libdir='$prefix/lib/$compiler' --libsubdir='$pkgid' $extraConfigureFlags $configureFlags

              eval "$postConfigure"
            '';

            # builds via Cabal
            buildPhase = ''
              eval "$preBuild"

              ./Setup build

              export GHC_PACKAGE_PATH=$(${ghc.GHCPackages})
              test -n "$noHaddock" || ./Setup haddock

              eval "$postBuild"
            '';

            checkPhase = optional self.doCheck ''
              eval "$preCheck"

              ./Setup test ${self.testTarget}

              eval "$postCheck"
            '';

            # installs via Cabal; creates a registration file for nix-support
            # so that the package can be used in other Haskell-builds; also
            # adds all propagated build inputs to the user environment packages
            installPhase = ''
              eval "$preInstall"

              ./Setup copy

              ensureDir $out/bin # necessary to get it added to PATH

              local confDir=$out/lib/ghc-${ghc.ghc.version}/package.conf.d
              local installedPkgConf=$confDir/${self.fname}.installedconf
              local pkgConf=$confDir/${self.fname}.conf
              ensureDir $confDir
              ./Setup register --gen-pkg-config=$pkgConf
              if test -f $pkgConf; then
                echo '[]' > $installedPkgConf
                GHC_PACKAGE_PATH=$installedPkgConf ghc-pkg --global register $pkgConf --force
              fi

              if test -f $out/nix-support/propagated-native-build-inputs; then
                ln -s $out/nix-support/propagated-native-build-inputs $out/nix-support/propagated-user-env-packages
              fi

              eval "$postInstall"
            '';

            # We inherit stdenv and ghc so that they can be used
            # in Cabal derivations.
            inherit stdenv ghc;
          };
    in  stdenv.mkDerivation (postprocess ((rec { f = defaults f // args f; }).f)) ;
}
