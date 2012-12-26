# generic builder for Cabal packages

{ stdenv, fetchurl, lib, pkgconfig, ghc, Cabal, jailbreakCabal, enableLibraryProfiling ? false }:
{
  mkDerivation =
    args : # arguments for the individual package, can modify the defaults
    let # These attributes are removed in the end. This is in order not to spoil the build
        # environment overly, but also to keep hash-backwards-compatible with the old cabal.nix.
        internalAttrs = [
          "internalAttrs" "buildDepends" "buildTools" "extraLibraries" "pkgconfigDepends"
          "isLibrary" "isExecutable"
        ];

        # Stuff happening after the user preferences have been processed. We remove
        # internal attributes and strip null elements from the dependency lists, all
        # in the interest of keeping hashes stable.
        postprocess =
          x : (removeAttrs x internalAttrs) // {
                buildInputs           = stdenv.lib.filter (y : ! (y == null)) x.buildInputs;
                propagatedBuildInputs = stdenv.lib.filter (y : ! (y == null)) x.propagatedBuildInputs;
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
                     if enableLibraryProfiling then
                       "haskell-${self.pname}-ghc${ghc.ghc.version}-${self.version}-profiling"
                     else
                       "haskell-${self.pname}-ghc${ghc.ghc.version}-${self.version}"
                   else
                     "${self.pname}-${self.version}";

            # the default download location for Cabal packages is Hackage,
            # you still have to specify the checksum
            src = fetchurl {
              url = "http://hackage.haskell.org/packages/archive/${self.pname}/${self.version}/${self.fname}.tar.gz";
              inherit (self) sha256;
            };

            # default buildInputs are just ghc, if more buildInputs are required
            # buildInputs can be extended by the client by using extraBuildInputs,
            # but often propagatedBuildInputs is preferable anyway
            buildInputs = [ghc Cabal] ++ self.extraBuildInputs;
            extraBuildInputs = self.buildTools ++
                               (if self.pkgconfigDepends == [] then [] else [pkgconfig]) ++
                               (if self.isLibrary then [] else self.buildDepends ++ self.extraLibraries ++ self.pkgconfigDepends);

            # we make sure that propagatedBuildInputs is defined, so that we don't
            # have to check for its existence
            propagatedBuildInputs = if self.isLibrary then self.buildDepends ++ self.extraLibraries ++ self.pkgconfigDepends else [];

            # library directories that have to be added to the Cabal files
            extraLibDirs = [];

            # build-depends Cabal field
            buildDepends = [];

            # build-tools Cabal field
            buildTools = [];

            # extra-libraries Cabal field
            extraLibraries = [];

            # pkgconfig-depends Cabal field
            pkgconfigDepends = [];

            isLibrary = ! self.isExecutable;
            isExecutable = false;

            libraryProfiling =
              if enableLibraryProfiling then ["--enable-library-profiling"]
                                        else ["--disable-library-profiling"];

            # compiles Setup and configures
            configurePhase = ''
              eval "$preConfigure"

              ${lib.optionalString (lib.attrByPath ["jailbreak"] false self) "${jailbreakCabal}/bin/jailbreak-cabal ${self.pname}.cabal && "
              }for i in Setup.hs Setup.lhs; do
                test -f $i && ghc --make $i
              done

              for p in $extraBuildInputs $propagatedBuildNativeInputs; do
                if [ -d "$p/include" ]; then
                  extraLibDirs="$extraLibDirs --extra-include-dir=$p/include"
                fi
                for d in lib{,64}; do
                  if [ -d "$p/$d" ]; then
                    extraLibDirs="$extraLibDirs --extra-lib-dir=$p/$d"
                  fi
                done
              done

              ./Setup configure --verbose --prefix="$out" $libraryProfiling $extraLibDirs $configureFlags

              eval "$postConfigure"
            '';

            # builds via Cabal
            buildPhase = ''
              eval "$preBuild"

              ./Setup build

              export GHC_PACKAGE_PATH=$(ghc-packages)
              [ -n "$noHaddock" ] || ./Setup haddock

              eval "$postBuild"
            '';

            # installs via Cabal; creates a registration file for nix-support
            # so that the package can be used in other Haskell-builds; also
            # adds all propagated build inputs to the user environment packages
            installPhase = ''
              eval "$preInstall"

              ./Setup copy

              ensureDir $out/bin # necessary to get it added to PATH

              local confDir=$out/lib/ghc-pkgs/ghc-${ghc.ghc.version}
              local installedPkgConf=$confDir/${self.fname}.installedconf
              local pkgConf=$confDir/${self.fname}.conf
              ensureDir $confDir
              ./Setup register --gen-pkg-config=$pkgConf
              if test -f $pkgConf; then
                echo '[]' > $installedPkgConf
                GHC_PACKAGE_PATH=$installedPkgConf ghc-pkg --global register $pkgConf --force
              fi

              eval "$postInstall"
            '';

            postFixup = ''
              if test -f $out/nix-support/propagated-build-native-inputs; then
                ln -s $out/nix-support/propagated-build-native-inputs $out/nix-support/propagated-user-env-packages
              fi
            '';

            # We inherit stdenv and ghc so that they can be used
            # in Cabal derivations.
            inherit stdenv ghc;
          };
    in  stdenv.mkDerivation (postprocess ((rec { f = defaults f // args f; }).f)) ;
}
