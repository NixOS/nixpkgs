# generic builder for Cabal packages

{ stdenv, fetchurl, lib, pkgconfig, ghc, Cabal, jailbreakCabal, glibcLocales
, gnugrep, coreutils, hscolour
, enableLibraryProfiling ? false
, enableSharedLibraries ? false
, enableSharedExecutables ? false
, enableStaticLibraries ? true
, enableCheckPhase ? stdenv.lib.versionOlder "7.4" ghc.version
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

# Cabal shipped with GHC 6.12.4 or earlier doesn't know the "--enable-tests configure" flag.
assert enableCheckPhase -> versionOlder "7" ghc.version;

# GHC prior to 7.4.x doesn't know the "--enable-executable-dynamic" flag.
assert enableSharedExecutables -> versionOlder "7.4" ghc.version;

# Our GHC 6.10.x builds do not provide sharable versions of their core libraries.
assert enableSharedLibraries -> versionOlder "6.12" ghc.version;

# Pure shared library builds don't work before GHC 7.8.x.
assert !enableStaticLibraries -> versionOlder "7.7" ghc.version;

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
                # Disable Darwin builds: <https://github.com/NixOS/nixpkgs/issues/2689>.
                meta                  = let meta = x.meta or {};
                                            hydraPlatforms = meta.hydraPlatforms or meta.platforms or [];
                                            noElem         = p: ps: !stdenv.lib.elem p ps;
                                            noDarwin       = p: noElem p stdenv.lib.platforms.darwin;
                                        in
                                        meta // { hydraPlatforms = filter noDarwin hydraPlatforms; };
              };

        defaults =
          self : 
          let
            # TODO: This should most certainly go into its respective ghc package (7.8.3.nix).
            # I'm however not sure of the implication of moving it there (binary package it would
            # invalidate), the form it should take and even if there could be a more automated
            # way of retrieving this listing.
            ghc783NativePkgsFNames = [
                "xhtml-3000.2.1"
                "unix-2.7.0.1"
                "transformers-0.3.0.0"
                "time-1.4.2"
                "terminfo-0.4.0.0"
                "template-haskell-2.9.0.0"
                "process-1.2.0.0"
                "pretty-1.1.1.1"
                "old-time-1.1.0.2"
                "old-locale-1.0.0.6"
                "integer-gmp-0.5.1.0"
                "hpc-0.6.0.1"
                "hoopl-3.10.0.1"
                "haskell2010-1.1.2.0"
                "haskell98-2.0.0.3"
                "haskeline-0.7.1.2"
                "ghc-prim-0.3.1.0"
                "ghc-7.8.3"
                "filepath-1.3.0.2"
                "directory-1.2.1.0"
                "deepseq-1.3.0.2"
                "containers-0.5.5.1"
                "Cabal-1.18.1.3"
                "bytestring-0.10.4.0"
                "bin-package-db-0.0.0.0"
                "binary-0.7.1.0"
                "base-4.7.0.1"
                "array-0.5.0.0"
            ];
            ghcNativePkgsFNames = 
              if "7.8.3" == ghc.version then 
                ghc783NativePkgsFNames
            else
                []; # TODO: Should be replace by native packages listing for other ghc versions.

            isHaskellPkg = x: (x ? pname) && (x ? version);
            isGhcPkg = x: (isHaskellPkg x) && (stdenv.lib.any (ghcPkgFn: x.fname == ghcPkgFn) ghcNativePkgsFNames);
            filterOutGhcPkgs = xs: stdenv.lib.filter (x: !(isGhcPkg x)) xs;
            # Prevent collisions / multiple registering of same lib to ghc-pkg when
            # a library is the same (name + version) as one of the libary natively
            # packaged with a ghc build.
            nonGhcBuildDepends = filterOutGhcPkgs self.buildDepends;
          in 
          { # self is the final version of the attribute set

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
              url = "mirror://hackage/${self.pname}/${self.fname}.tar.gz";
              inherit (self) sha256;
            };

            # default buildInputs are just ghc, if more buildInputs are required
            # buildInputs can be extended by the client by using extraBuildInputs,
            # but often propagatedBuildInputs is preferable anyway
            buildInputs = [ghc Cabal] ++ self.extraBuildInputs;
            extraBuildInputs = self.buildTools ++
                               (optionals self.doCheck self.testDepends) ++
                               (optional self.hyperlinkSource hscolour) ++
                               (if self.pkgconfigDepends == [] then [] else [pkgconfig]) ++
                               (if self.isLibrary then [] else nonGhcBuildDepends ++ self.extraLibraries ++ self.pkgconfigDepends);

            # we make sure that propagatedBuildInputs is defined, so that we don't
            # have to check for its existence
            propagatedBuildInputs = if self.isLibrary then nonGhcBuildDepends ++ self.extraLibraries ++ self.pkgconfigDepends else [];

            # By default, also propagate all dependencies to the user environment. This is required, otherwise packages would be broken, because
            # GHC also needs all dependencies to be available.
            propagatedUserEnvPkgs = if self.isLibrary then nonGhcBuildDepends else [];

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
            enableSplitObjs = !stdenv.isDarwin;         # http://hackage.haskell.org/trac/ghc/ticket/4013

            # pass the '--enable-tests' flag to cabal in the configure stage
            # and run any regression test suites the package might have
            doCheck = enableCheckPhase;

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
              (enableFeature self.enableSharedLibraries "shared")
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

              ${optionalString self.jailbreak "${jailbreakCabal}/bin/jailbreak-cabal ${self.pname}.cabal"}

              for i in Setup.hs Setup.lhs ${defaultSetupHs}; do
                test -f $i && break
              done
              ghc --make -o Setup -odir $TMPDIR -hidir $TMPDIR $i

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

              ${optionalString (self.enableSharedExecutables && self.stdenv.isLinux) ''
                configureFlags+=" --ghc-option=-optl=-Wl,-rpath=$out/lib/${ghc.ghc.name}/${self.pname}-${self.version}"
              ''}
              ${optionalString (self.enableSharedExecutables && self.stdenv.isDarwin) ''
                configureFlags+=" --ghc-option=-optl=-Wl,-headerpad_max_install_names"
              ''}
              ${optionalString (versionOlder "7.8" ghc.version && !self.isLibrary) ''
                configureFlags+=" --ghc-option=-j$NIX_BUILD_CORES"
              ''}

              echo "configure flags: $extraConfigureFlags $configureFlags"
              ./Setup configure --verbose --prefix="$out" --libdir='$prefix/lib/$compiler' \
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
              test -n "$noHaddock" || ./Setup haddock --html --hoogle \
                  ${optionalString self.hyperlinkSource "--hyperlink-source"}

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

              local confDir=$out/lib/ghc-${ghc.ghc.version}/package.conf.d
              local installedPkgConf=$confDir/${self.fname}.installedconf
              local pkgConf=$confDir/${self.fname}.conf
              mkdir -p $confDir
              ./Setup register --gen-pkg-config=$pkgConf
              if test -f $pkgConf; then
                echo '[]' > $installedPkgConf
                GHC_PACKAGE_PATH=$installedPkgConf ghc-pkg --global register $pkgConf --force
              fi

              if test -f $out/nix-support/propagated-native-build-inputs; then
                ln -s $out/nix-support/propagated-native-build-inputs $out/nix-support/propagated-user-env-packages
              fi

              ${optionalString (self.enableSharedExecutables && self.isExecutable && self.stdenv.isDarwin) ''
                for exe in "$out/bin/"* ; do
                  install_name_tool -add_rpath \
                    $out/lib/${ghc.ghc.name}/${self.pname}-${self.version} $exe
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
