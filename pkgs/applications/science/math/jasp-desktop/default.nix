{ lib
, stdenv
, fetchFromGitHub
, cmake
, copyDesktopItems
, glew
, libffi
, wrapQtAppsHook
, qtbase
, qtmultimedia
, libzip
, makeDesktopItem
, makeWrapper
, pkg-config
, python3
, snappy
, vulkan-loader
, wayland
, boost179
, jsoncpp
, libarchive
, openssl
, zlib
, bison
, flex
, gfortran
, qtwebengine
, qt5compat
, readstat
, rWrapper
, substituteAll
, rPackages
, jags
, qtcreator
}:

let
  R = rWrapper.override { packages = with rPackages; [ renv RInside ]; };
in
stdenv.mkDerivation rec {
  pname = "jasp-desktop";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "jasp-stats";
    repo = "jasp-desktop";
    rev = "v${version}";
    hash = "sha256-1m0URudMF50pnR7xYuu/d5817ouybaNLTG/h2d1J7rY=";
  };

  patches = [
    (substituteAll {
      src = ./no-static-boost.patch;
      r_include = "${R}/lib/R/include";
    })
  ];

  R_HOME = "${R}";

  nativeBuildInputs = [
    cmake
    qtcreator
    copyDesktopItems
    makeWrapper
    pkg-config
    wrapQtAppsHook
    gfortran
  ];

  buildInputs = [
    boost179
    jsoncpp
    libarchive
    openssl
    readstat
    R
    jags
    zlib
    bison
    flex
    qtbase
    qtmultimedia
    qtwebengine
    qt5compat
  ];

  cmakeFlags = [
    "-DLINUX_LOCAL_BUILD=OFF"
    "-DAPPLE=OFF"
    "-DWIN32=OFF"
    "-DRENV_PATH=${rPackages.renv}/library/renv"
    "-DRINSIDE_PATH=${rPackages.RInside}/library/RInside"
    "-Djags_HOME=${jags}"
  ];

  GITHUB_PAT = "xxx";

  meta = {
    homepage = "https://jasp-stats.org/";
    description = "Statistical package for both Bayesian and Frequentist statistical methods";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.fliegendewurst ];
    platforms = lib.platforms.linux; # TODO: package for darwin
  };
}
