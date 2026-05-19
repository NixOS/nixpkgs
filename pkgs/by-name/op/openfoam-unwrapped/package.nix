{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  cgal_5,
  zlib,
  gmp,
  gnum4,
  boost,
  fftw,
  flex,
  openmpi,
  scotch,
  symlinkJoin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openfoam-unwrapped";
  version = "2512";

  src = fetchFromGitLab {
    owner = "OpenFOAM/core";
    repo = "openfoam";
    tag = "OpenFOAM-v${finalAttrs.version}";
    hash = "sha256-uaXA0sFso6W+1jE2/2G0ckQlqRGnP/QBk0aHzP7xTWw=";
  };

  sourceRoot = ".";

  strictDeps = true;
  __structuredAttrs = true;

  dontUseCmakeConfigure = true;
  dontFixup = true;

  buildInputs = [
    zlib
    gmp
    gmp.dev
    boost
    flex
    openmpi
    openmpi.dev
  ];

  nativeBuildInputs = [
    cmake
    flex
    gnum4
    openmpi.dev
  ];

  patchPhase =
    let
      scotchCombined = symlinkJoin {
        name = "scotch-combined";
        paths = [
          scotch.dev
          scotch.out
        ];
      };

      fftwCombined = symlinkJoin {
        name = "fftw-combined";
        paths = [
          fftw.dev
          fftw.out
        ];
      };

      boostCombined = symlinkJoin {
        name = "boost-combined";
        paths = [
          boost.dev
          boost.out
        ];
      };
    in
    ''
      runHook prePatch

      patchShebangs --build .

      substituteInPlace source/etc/config.sh/scotch \
        --replace-fail \
          'SCOTCH_VERSION=scotch_6.1.0' \
          'SCOTCH_VERSION=scotch-system' \
        --replace-fail \
          'export SCOTCH_ARCH_PATH=$WM_THIRD_PARTY_DIR/platforms/$WM_ARCH$WM_COMPILER$WM_PRECISION_OPTION$WM_LABEL_OPTION/$SCOTCH_VERSION' \
          'export SCOTCH_ARCH_PATH=${scotchCombined}'

      substituteInPlace source/etc/config.sh/FFTW \
        --replace-fail \
          'fftw_version=fftw-3.3.10' \
          'fftw_version=fftw-system' \
        --replace-fail \
          'export FFTW_ARCH_PATH=$WM_THIRD_PARTY_DIR/platforms/$WM_ARCH$WM_COMPILER/$fftw_version' \
          'export FFTW_ARCH_PATH=${fftwCombined}'

      substituteInPlace source/etc/config.sh/CGAL \
        --replace-fail \
          'cgal_version=CGAL-4.14.3' \
          'cgal_version=cgal-system' \
        --replace-fail \
          'export CGAL_ARCH_PATH="$WM_THIRD_PARTY_DIR/platforms/$WM_ARCH$WM_COMPILER/$cgal_version"' \
          'export CGAL_ARCH_PATH="${cgal_5}"'

      substituteInPlace source/etc/config.sh/CGAL \
        --replace-fail \
          'boost_version=boost_1_74_0' \
          'boost_version=boost-system' \
        --replace-fail \
          'export BOOST_ARCH_PATH="$WM_THIRD_PARTY_DIR/platforms/$WM_ARCH$WM_COMPILER/$boost_version"' \
          'export BOOST_ARCH_PATH="${boostCombined}"'

      export HOME="$PWD/builduser"

      mkdir -p "$HOME/OpenFOAM"
      mkdir -p "$HOME/.OpenFOAM"

      mv source "$HOME/OpenFOAM/OpenFOAM-${finalAttrs.version}"

      runHook postPatch
    '';

  buildPhase = ''
    runHook preBuild

    cd "$HOME/OpenFOAM/OpenFOAM-${finalAttrs.version}"

    set +eu
    source ./etc/bashrc
    set -eu

    ./Allwmake -j "$NIX_BUILD_CORES" -q -s

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    OUT_DIR="$out/opt/OpenFOAM-${finalAttrs.version}"

    mkdir -p "$OUT_DIR"
    cp -r . "$OUT_DIR"

    runHook postInstall
  '';

  passthru = {
    tests.foamInstallation = stdenv.mkDerivation {
      name = "openfoam-installation-test";

      nativeBuildInputs = [
        finalAttrs.finalPackage
        flex
        openmpi
      ];

      dontUnpack = true;

      buildPhase = ''
        set +eu
        source ${finalAttrs.finalPackage}/opt/OpenFOAM-${finalAttrs.version}/etc/bashrc
        set -eu

        foamInstallationTest > test.log 2>&1
        cat test.log

        if grep -q 'fatal error' test.log; then
          exit 1
        fi
      '';

      installPhase = ''
        touch "$out"
      '';
    };
  };

  meta = {
    description = "OpenFOAM is an open-source CFD toolkit for solving fluid flow, turbulence, heat transfer, chemical reactions, and multiphysics problems";
    homepage = "https://openfoam.com";
    downloadPage = "https://gitlab.com/openfoam/core/openfoam";
    changelog = "https://www.openfoam.com/news/main-news/openfoam-v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ Zirconium419122 ];
    platforms = lib.platforms.all;
  };
})
