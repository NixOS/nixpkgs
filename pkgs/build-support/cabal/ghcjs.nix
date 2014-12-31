# generic builder for Cabal packages

{ stdenv, fetchurl, lib, pkgconfig, ghcjs, ghc, Cabal, jailbreakCabal, glibcLocales
, gnugrep, coreutils, hscolour # hscolour is unused
, enableLibraryProfiling ? false
, enableSharedLibraries ? false
, enableSharedExecutables ? false
, enableStaticLibraries ? true
, enableCheckPhase ? stdenv.lib.versionOlder "7.4" ghc.version
, enableHyperlinkSource ? false
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
                propagatedUserEnvPkgs = filter (y : ! (y == null)) x.propagatedUserEnvPkgs;
                doCheck               = enableCheckPhase && x.doCheck;
                hyperlinkSource       = enableHyperlinkSource && x.hyperlinkSource;
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
                       "haskell-${self.pname}-ghcjs${ghc.ghc.version}-${self.version}-profiling-shared"
                     else if enableLibraryProfiling && !self.enableSharedLibraries then
                       "haskell-${self.pname}-ghcjs${ghc.ghc.version}-${self.version}-profiling"
                     else if !enableLibraryProfiling && self.enableSharedLibraries then
                       "haskell-${self.pname}-ghcjs${ghc.ghc.version}-${self.version}-shared"
                     else
                       "haskell-${self.pname}-ghcjs${ghc.ghc.version}-${self.version}"
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
            buildInputs = [ghc ghc.ghc.parent.Cabal_HEAD] ++ self.extraBuildInputs;
            extraBuildInputs = self.buildTools ++
                               (optionals self.doCheck self.testDepends) ++
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

            # ignore version restrictions on the build inputs that the cabal file might specify
            jailbreak = false;

            # pass the '--enable-split-objs' flag to cabal in the configure stage
            enableSplitObjs = false; # !stdenv.isDarwin;         # http://hackage.haskell.org/trac/ghc/ticket/4013

            # pass the '--enable-tests' flag to cabal in the configure stage
            # and run any regression test suites the package might have
            doCheck = false; #enableCheckPhase;

            # pass the '--hyperlink-source' flag to ./Setup haddock
            hyperlinkSource = enableHyperlinkSource;

            # abort the build if the configure phase detects that the package
            # depends on multiple versions of the same build input
            strictConfigurePhase = true;

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
              (enableFeature true "shared")
              (optional (versionOlder "7" ghc.version) (enableFeature self.enableStaticLibraries "library-vanilla"))
              (optional (versionOlder "7.4" ghc.version) (enableFeature self.enableSharedExecutables "executable-dynamic"))
              (optional (versionOlder "7" ghc.version) (enableFeature self.doCheck "tests"))
            ];

            # GHC needs the locale configured during the Haddock phase.
            LANG = "en_US.UTF-8";
            LOCALE_ARCHIVE = optionalString stdenv.isLinux "${glibcLocales}/lib/locale/locale-archive";

            # compiles Setup and configures
            configurePhase = ''
              eval "$preConfigure"

              ${optionalString self.jailbreak "${ghc.ghc.parent.jailbreakCabal}/bin/jailbreak-cabal ${self.pname}.cabal"}

              PATH=$PATH:${ghc.ghc.ghc}/bin

              for i in Setup.hs Setup.lhs ${defaultSetupHs}; do
                test -f $i && break
              done
              ghc --make -o Setup -odir $TMPDIR -hidir $TMPDIR $i

              for p in $extraBuildInputs $propagatedBuildInputs $propagatedNativeBuildInputs; do
                PkgDir="$p/lib/ghcjs-${ghc.ghc.version}_ghc-${ghc.ghc.ghc.version}/package.conf.d"
                if [ -f "$PkgDir/package.cache" ]; then
                  extraConfigureFlags+=" --package-db=$PkgDir"
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

              configureFlags+=" --package-db=${ghc.ghc}/${ghc.ghc.libDir}/package.conf.d"

              ${optionalString (self.enableSharedExecutables && self.stdenv.isLinux) ''
                configureFlags+=" --ghc-option=-optl=-Wl,-rpath=$out/lib/${ghc.ghc.name}/${self.pname}-${self.version}";
              ''}
              ${optionalString (self.enableSharedExecutables && self.stdenv.isDarwin) ''
                configureFlags+=" --ghc-option=-optl=-Wl,-headerpad_max_install_names";
              ''}

              echo "configure flags: $extraConfigureFlags $configureFlags"
              ./Setup configure --ghcjs --verbose --prefix="$out" --libdir='$prefix/lib/$compiler' \
                --libsubdir='$pkgid' $extraConfigureFlags $configureFlags 2>&1 \
              ${optionalString self.strictConfigurePhase ''
                | ${coreutils}/bin/tee "$NIX_BUILD_TOP/cabal-configure.log"
                if ${gnugrep}/bin/egrep -q '^Warning:.*depends on multiple versions' "$NIX_BUILD_TOP/cabal-configure.log"; then
                  echo >&2 "*** abort because of serious configure-time warning from Cabal"
                  exit 1
                fi
              ''}

              eval "$postConfigure"
            '';

            # builds via Cabal
            buildPhase = ''
              eval "$preBuild"

              ./Setup build ${self.buildTarget}

              export GHC_PACKAGE_PATH=$(${ghc.GHCPackages})
              #test -n "$noHaddock" || ./Setup haddock --html --hoogle \
              #    ${optionalString self.hyperlinkSource "--hyperlink-source"}

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

              mkdir -p $out/bin # necessary to get it added to PATH

              local confDir=$out/lib/ghcjs-${ghc.ghc.version}_ghc-${ghc.ghc.ghc.version}/package.conf.d
              local installedPkgConf=$confDir/${self.fname}.installedconf
              local pkgConf=$confDir/${self.fname}.conf
              mkdir -p $confDir
              ./Setup register --gen-pkg-config=$pkgConf
              if test -f $pkgConf; then
                echo '[]' > $installedPkgConf
                GHC_PACKAGE_PATH=$installedPkgConf ghcjs-pkg --global register $pkgConf --force --package-db=$confDir || true
                ghcjs-pkg recache --package-db=$confDir
              fi

              if test -f $out/nix-support/propagated-native-build-inputs; then
                ln -s $out/nix-support/propagated-native-build-inputs $out/nix-support/propagated-user-env-packages
              fi

              ${optionalString (self.enableSharedExecutables && self.isExecutable && self.stdenv.isDarwin) ''
                for exe in $out/bin/* ; do
                  install_name_tool -add_rpath $out/lib/${ghc.ghc.name}/${self.pname}-${self.version} $exe || true # Ignore failures, which seem to be due to hitting bash scripts rather than binaries
                done
              ''}

              eval "$postInstall"
            '';

            # We inherit stdenv and ghc so that they can be used
            # in Cabal derivations.
            inherit stdenv ghc;
          };
    in
    stdenv.mkDerivation (postprocess (let super = defaults self // args self;
                                          self  = super // extension self super;
                                      in self));
}
