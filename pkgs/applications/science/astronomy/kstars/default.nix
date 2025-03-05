{
  lib,
  stdenv,
  extra-cmake-modules,
  fetchurl,
  fetchFromGitLab,
  fetchpatch,
  kconfig,
  kdoctools,
  kguiaddons,
  ki18n,
  kinit,
  kiconthemes,
  kio,
  knewstuff,
  kplotting,
  kwidgetsaddons,
  kxmlgui,
  knotifyconfig,
  qtx11extras,
  qtwebsockets,
  qtkeychain,
  qtdatavis3d,
  wrapQtAppsHook,
  breeze-icons,
  libsecret,
  eigen,
  zlib,
  cfitsio,
  indi-full,
  xplanet,
  libnova,
  libraw,
  gsl,
  wcslib,
  stellarsolver,
  libxisf,
  curl,
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
  version = "3.7.4";

  src = fetchurl {
    url = "mirror://kde/stable/kstars/${finalAttrs.version}/kstars-${finalAttrs.version}.tar.xz";
    hash = "sha256-WdVsPCwDQWW/NIRehuqk5f8rgtucAbGLSbmwZLMLiHM=";
  };

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    wrapQtAppsHook
  ];
  buildInputs = [
    kconfig
    kdoctools
    kguiaddons
    ki18n
    kinit
    kiconthemes
    kio
    knewstuff
    kplotting
    kwidgetsaddons
    kxmlgui
    knotifyconfig
    qtx11extras
    qtwebsockets
    qtkeychain
    qtdatavis3d
    breeze-icons
    libsecret
    eigen'
    zlib
    cfitsio
    indi-full
    xplanet
    libnova
    libraw
    gsl
    wcslib
    stellarsolver
    libxisf
    curl
  ];

  cmakeFlags = [
    "-DINDI_PREFIX=${indi-full}"
    "-DXPLANET_PREFIX=${xplanet}"
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
    ];
  };
})
