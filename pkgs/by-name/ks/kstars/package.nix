{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitLab,
  fetchpatch,
  cfitsio,
  cmake,
  curl,
  eigen,
  gsl,
  indi-full,
  kdePackages,
  libnova,
  libraw,
  libsecret,
  libxisf,
  opencv,
  stellarsolver,
  wcslib,
  xplanet,
  zlib,
}:

let
  # reverts 'eigen: 3.4.0 -> 3.4.0-unstable-2022-05-19'
  # https://github.com/nixos/nixpkgs/commit/d298f046edabc84b56bd788e11eaf7ed72f8171c
  eigen' = eigen.overrideAttrs (old: rec {
    version = "3.4.0";
    src = fetchFromGitLab {
      owner = "libeigen";
      repo = "eigen";
      rev = version;
      hash = "sha256-1/4xMetKMDOgZgzz3WMxfHUEpmdAm52RqZvz6i0mLEw=";
    };
    patches = (old.patches or [ ]) ++ [
      # Fixes e.g. onnxruntime on aarch64-darwin:
      # https://hydra.nixos.org/build/248915128/nixlog/1,
      # originally suggested in https://github.com/NixOS/nixpkgs/pull/258392.
      #
      # The patch is from
      # ["Fix vectorized reductions for Eigen::half"](https://gitlab.com/libeigen/eigen/-/merge_requests/699)
      # which is two years old,
      # but Eigen hasn't had a release in two years either:
      # https://gitlab.com/libeigen/eigen/-/issues/2699.
      (fetchpatch {
        url = "https://gitlab.com/libeigen/eigen/-/commit/d0e3791b1a0e2db9edd5f1d1befdb2ac5a40efe0.patch";
        hash = "sha256-8qiNpuYehnoiGiqy0c3Mcb45pwrmc6W4rzCxoLDSvj0=";
      })
    ];
  });
in

stdenv.mkDerivation (finalAttrs: {
  pname = "kstars";
  version = "3.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/kstars/${finalAttrs.version}/kstars-${finalAttrs.version}.tar.xz";
    hash = "sha256-L9hyVfdgFlFfM6MyjR4bUa86FHPbVg7xBWPY8YSHUXw=";
  };

  nativeBuildInputs = with kdePackages; [
    extra-cmake-modules
    kdoctools
    wrapQtAppsHook
    cmake
  ];
  buildInputs = with kdePackages; [
    breeze-icons
    cfitsio
    curl
    eigen'
    gsl
    indi-full
    kconfig
    kdoctools
    kguiaddons
    ki18n
    kiconthemes
    kio
    knewstuff
    knotifyconfig
    kplotting
    kwidgetsaddons
    kxmlgui
    libnova
    libraw
    libsecret
    libxisf
    opencv
    qtdatavis3d
    qtkeychain
    qtsvg
    qtwayland
    qtwebsockets
    stellarsolver
    wcslib
    xplanet
    zlib
  ];

  cmakeFlags = with lib.strings; [
    (cmakeBool "BUILD_QT5" false)
    (cmakeFeature "INDI_PREFIX" "${indi-full}")
    (cmakeFeature "XPLANET_PREFIX" "${xplanet}")
    (cmakeFeature "DATA_INSTALL_DIR" "$out/share/kstars/")
  ];

  meta = with lib; {
    description = "Virtual planetarium astronomy software";
    mainProgram = "kstars";
    homepage = "https://kde.org/applications/education/org.kde.kstars";
    longDescription = ''
      It provides an accurate graphical simulation of the night sky, from any location on Earth, at any date and time.
      The display includes up to 100 million stars, 13.000 deep-sky objects, all 8 planets, the Sun and Moon, and thousands of comets, asteroids, supernovae, and satellites.
      For students and teachers, it supports adjustable simulation speeds in order to view phenomena that happen over long timescales, the KStars Astrocalculator to predict conjunctions, and many common astronomical calculations.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      timput
      hjones2199
      returntoreality
    ];
  };
})
