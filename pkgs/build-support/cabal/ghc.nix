{self, haskellCompiler, lib, coreutils, gnugrep, defaultSetupHs, jailbreakCabal, optional, optionalString}:
let
  ghc = haskellCompiler;
in
{

  # compiles Setup and configures
  configurePhase = ''
    eval "$preConfigure"

    # Trigger the creation of an unique package-db for the current build
    export NIX_GHC_PKG_DIR_OVERRIDE="$(mktemp -d --dry-run --tmpdir=$TMPDIR)"

    ${optionalString self.jailbreak "${jailbreakCabal}/bin/jailbreak-cabal ${self.pname}.cabal"}

    for i in Setup.hs Setup.lhs ${defaultSetupHs}; do
      test -f $i && break
    done
    ghc --make -o Setup -odir $TMPDIR $i

    for p in $extraBuildInputs $propagatedNativeBuildInputs; do
      if [ -d "$p/lib/ghc-${ghc.ghcPlain.version}/package.conf.d" ]; then
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
      configureFlags+=" --ghc-option=-optl=-Wl,-rpath=$out/lib/${ghc.ghcPlain.name}/${self.pname}-${self.version}"
    ''}
    ${optionalString (self.enableSharedExecutables && self.stdenv.isDarwin) ''
      configureFlags+=" --ghc-option=-optl=-Wl,-headerpad_max_install_names"
    ''}
    ${optionalString (lib.versionOlder "7.8" ghc.version) ''
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

    test -n "$noHaddock" || GHC_PACKAGE_PATH="$NIX_GHC_PKG_DIR_OVERRIDE": ./Setup haddock --html --hoogle \
        ${optionalString self.hyperlinkSource "--hyperlink-source"}

    eval "$postBuild"
  '';

  checkPhase = optional self.doCheck ''
    eval "$preCheck"

    # export GHC_PACKAGE_PATH as it seems to be needed by doctest
    GHC_PACKAGE_PATH="$NIX_GHC_PKG_DIR_OVERRIDE": ./Setup test ${self.testTarget}

    eval "$postCheck"
  '';

  # installs via Cabal; creates a registration file for nix-support
  # so that the package can be used in other Haskell-builds; also
  # adds all propagated build inputs to the user environment packages
  installPhase = ''
    eval "$preInstall"

    ./Setup copy

    mkdir -p $out/bin # necessary to get it added to PATH

    local confDir=$out/lib/ghc-${ghc.ghcPlain.version}/package.conf.d
    local installedPkgConf=$confDir/${self.fname}.installedconf #TODO: remove, only kept for compatibility
    local pkgConf=$confDir/${self.fname}.conf
    mkdir -p $confDir
    ./Setup register --gen-pkg-config=$pkgConf
    #TODO: remove the if case, only kept for compatibility
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
          $out/lib/${ghc.ghcPlain.name}/${self.pname}-${self.version} $exe
      done
    ''}

    ${optionalString self.wrapExecutables ''
      if [ -d "$out/bin" ]; then
        for exe in `ls $out/bin`; do
            mv $out/bin/$exe $out/bin/.$exe-wrapped
            cp ${ghc}/nix-build-helpers/haskell/mkGHCWrapperContent.txt $out/bin/$exe
            sed -i 's@__NIX_GHC_HASKELL_WRAPPER_TARGET__@'$out/bin/.$exe-wrapped'@' $out/bin/$exe
            chmod +x $out/bin/$exe
        done
      fi
    ''}

    eval "$postInstall"
  '';

}
