{
  lib,
  stdenv,
  fetchFromGitLab,
  bash,
  mpi,
  gmp,
  mpfr,
  gnum4,
  makeWrapper,
  makeOverridable,
  flex,
  zlib,
  scotch,
  cgal,
  metis,
  fftw,
  boost,
  bison,
  removeReferencesTo,
  callPackage,

  # Args to override
  version,
  sourceRev,
  sourceHash,
}:
stdenv.mkDerivation (
  finalAttrs:
  let
    # NOTE: openfoam-com recommends scotch 6, see https://develop.openfoam.com/Development/openfoam/-/commit/0a01492397dc8dcad003f36c7b63adda0ec5bcf1
    scotch_6 = scotch.overrideAttrs (prev: rec {
      version = "6.1.3";

      src = fetchFromGitLab {
        domain = "gitlab.inria.fr";
        owner = "scotch";
        repo = "scotch";
        rev = "v${version}";
        hash = "sha256-MBrsx/AV7OxXhKTqsGQ0ronEykOkaSO7jxUMrH+eJao=";
      };

      nativeBuildInputs = [ ];

      buildInputs = [
        bison
        mpi
        flex
        zlib
      ];

      preConfigure = ''
        cd src
        ln -s Make.inc/Makefile.inc.x86-64_pc_linux2 Makefile.inc
      '';

      buildFlags = [ "scotch ptscotch" ];

      installFlags = [ "prefix=\${out}" ];
    });
  in
  {
    pname = "openfoam-com";

    inherit version;

    src = fetchFromGitLab {
      domain = "develop.openfoam.com";
      owner = "Development";
      repo = "openfoam";
      rev = sourceRev;
      hash = sourceHash;
    };

    nativeBuildInputs = [
      makeWrapper
      bash
      gnum4
      flex
      removeReferencesTo
    ];

    buildInputs =
      [
        boost
        cgal
        fftw
        metis
        mpi
        scotch_6
        zlib
      ]
      ++ lib.optionals (lib.strings.versionOlder finalAttrs.version "2306") [
        gmp
        mpfr
      ];

    outputs = [
      "out"
      "dev"
      "tutorials"
    ];

    stripDebugList = [ "platforms" ];
    separateDebugInfo = true;

    postPatch =
      ''
        patchShebangs ./

        echo "system dependencies" > ThirdParty
      ''
      + lib.optionalString (lib.strings.versionOlder finalAttrs.version "2406") ''
        substituteInPlace wmake/rules/General/Gcc/c++ \
          --replace-fail "-std=c++11" "-std=c++14 -D_GLIBCXX_USE_CXX14_ABI=0"
      '';

    configurePhase = ''
      bin/tools/foamConfigurePaths \
        -cgal-path "${cgal}" \
        -metis-path "${metis}"

      substituteInPlace wmake/scripts/have_scotch \
        --replace-fail "local warn=\"==> skip scotch\"" \
          " \
            export HAVE_SCOTCH=true \
            SCOTCH_ARCH_PATH="${scotch_6.dev}" \
            SCOTCH_INC_DIR="${scotch_6.dev}/include" \
            SCOTCH_LIB_DIR="${scotch_6}/lib" \
            SCOTCH_VERSION="${scotch_6.version}" \
          " \
        --replace-fail "local incName=\"scotch.h\"" "return 0"

      substituteInPlace wmake/scripts/have_scotch \
        --replace-fail "local warn=\"==> skip ptscotch\"" \
          " \
            export HAVE_PTSCOTCH=true \
            PTSCOTCH_ARCH_PATH="${scotch_6.dev}" \
            PTSCOTCH_INC_DIR="${scotch_6.dev}/include" \
            PTSCOTCH_LIB_DIR="${scotch_6}/lib" \
          " \
        --replace-fail "local incName=\"ptscotch.h\"" "return 0"

      substituteInPlace wmake/scripts/have_fftw \
        --replace-fail "local incName=\"fftw3.h\"" \
            " \
            export HAVE_FFTW=true \
            FFTW_ARCH_PATH="${fftw.dev}" \
            FFTW_INC_DIR="${fftw.dev}/include" \
            FFTW_LIB_DIR="${fftw}/lib" \
            " \
        --replace-fail "local libName=\"libfftw3\"" \ "return 0"

      substituteInPlace wmake/scripts/have_boost \
        --replace-fail "local incName=\"boost/version.hpp\"" \
            " \
            export HAVE_BOOST=true \
            BOOST_ARCH_PATH="${boost.dev}" \
            BOOST_INC_DIR="${boost.dev}/include" \
            BOOST_LIB_DIR="${boost}/lib" \
            " \
        --replace-fail "local libName=\"libboost_system\"" \ "return 0"

      bin/tools/create-mpi-config -write-openmpi

      set +e
      source etc/bashrc
      set -e
    '';

    buildPhase = ''
      export WM_NCOMPPROCS="$NIX_BUILD_CORES"

      ./Allwmake -j -q
    '';

    installPhase = ''
      mkdir -p "$out" "$dev" "$tutorials"

      cp -av bin "$out/bin"
      cp -av etc "$out/etc"
      cp -av META-INFO "$out/META-INFO"
      cp -av ThirdParty "$out/ThirdParty"

      mkdir -p "$out/platforms"
      cp -av "platforms/$WM_OPTIONS" "$out/platforms/$WM_OPTIONS"

      cp -av wmake "$out/wmake"
      cp -av Allwmake "$out/Allwmake"

      mkdir -p "$out/platforms/tools"
      cp -av "platforms/tools/$WM_ARCH$WM_COMPILER" "$out/platforms/tools/$WM_ARCH$WM_COMPILER"

      cp -av applications "$dev/applications"
      cp -av src "$dev/src"

      cp -av tutorials "$tutorials/tutorials"
    '';

    postFixup = ''
      substituteInPlace $out/etc/bashrc \
        --replace-fail "# projectDir=\"@PROJECT_DIR@\"" "projectDir=\"$out\""

      substituteInPlace $out/etc/config.sh/settings \
        --replace-fail "export FOAM_SRC=\"\$WM_PROJECT_DIR/src\"" "export FOAM_SRC=\"\$NIX_OPENFOAM_COM_DEV/src\"" \
        --replace-fail "export FOAM_TUTORIALS=\"\$WM_PROJECT_DIR/tutorials\"" "export FOAM_TUTORIALS=\"\$NIX_OPENFOAM_COM_TUTORIALS/tutorials\""

      substituteInPlace $out/wmake/makefiles/general \
        --replace-fail "\$(WM_PROJECT_DIR)/src" "\$(NIX_OPENFOAM_COM_DEV)/src" \
        --replace-fail "\$(WM_PROJECT_DIR)/applications" "\$(NIX_OPENFOAM_COM_DEV)/applications"

      substituteInPlace $out/bin/foamTestTutorial \
        --replace-fail "cp -f" "cp -f --no-preserve=mode" \
        --replace-fail "cp -r \"\$FOAM_TUTORIALS/\$testdir\"/* \"\$TESTDIR\"/" " \
          cp -r --no-preserve=mode \"\$FOAM_TUTORIALS/\$testdir\"/* \"\$TESTDIR\"/;
          find \"\$FOAM_TUTORIALS/\$testdir\"/ -type f -executable | while read -r file; do \
              chmod +x \"\$TESTDIR\"/\"\''${file#\"\$FOAM_TUTORIALS/\$testdir\"/}\"; \
          done \
        "

      remove-references-to -t ${boost.dev} $out/etc/config.sh/* $out/wmake/scripts/*
      remove-references-to -t ${boost} $out/etc/config.sh/* $out/wmake/scripts/*
      remove-references-to -t ${fftw.dev} $out/etc/config.sh/* $out/wmake/scripts/*
      remove-references-to -t ${fftw} $out/etc/config.sh/* $out/wmake/scripts/*
      remove-references-to -t ${scotch_6.dev} $out/etc/config.sh/* $out/wmake/scripts/*
      remove-references-to -t ${scotch_6} $out/etc/config.sh/* $out/wmake/scripts/*

      grep -F -l WM_PROJECT_DIR "$out/bin/foam"* | while read -r program; do
        wrapProgram "$program" \
          --run "set +e; source \"$out/etc/bashrc\"; set -e"
      done

      echo "creating a bin of wrapped binaries from $out/platforms/$WM_OPTIONS/bin"
      for program in "$out/platforms/$WM_OPTIONS/bin/"*; do
        makeWrapper "$program" "$out/bin/''${program##*/}" \
          --run "set +e; source \"$out/etc/bashrc\"; set -e"

        makeWrapper "${mpi}/bin/mpirun" "$out/bin/''${program##*/}-mpi" \
          --add-flags "-n \"\$(ls -d processor* | wc -l)\" \"$out/bin/''${program##*/}\" -parallel" \
          --run "[ -r processor0 ] || { echo \"Case is not currently decomposed, see decomposePar documentation\"; exit 1; }" \
          --run "set +e; source \"$out/etc/bashrc\"; set -e"
      done
    '';

    disallowedReferences = [
      boost.dev
      scotch_6.dev
      fftw.dev
    ];

    passthru =
      let
        openfoam = finalAttrs.finalPackage;
      in
      {
        tests = callPackage ./tests.nix { inherit openfoam; };

        mkExtension = callPackage ./mk-extension.nix { inherit openfoam stdenv mpi; };
      };

    meta = with lib; {
      description = "Free, open source CFD software";
      homepage = "https://develop.openfoam.com/Development/openfoam.git";
      changelog = "https://www.openfoam.com/news/main-news/openfoam-${version}";
      license = licenses.gpl3Only;
      maintainers = with maintainers; [ razielgn ];
      platforms = lib.platforms.linux;
    };
  }
)
