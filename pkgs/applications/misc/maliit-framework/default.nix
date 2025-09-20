{
  mkDerivation,
  lib,
  fetchFromGitHub,
  fetchpatch,

  qtbase,

  at-spi2-atk,
  at-spi2-core,
  libepoxy,
  gtk3,
  libdatrie,
  libselinux,
  libsepol,
  libthai,
  pcre,
  util-linux,
  wayland,
  xorg,

  cmake,
  doxygen,
  graphviz,
  pkg-config,
  wayland-protocols,
  wayland-scanner,
}:

mkDerivation {
  pname = "maliit-framework";
  version = "2.3.0-unstable-2024-06-24";

  src = fetchFromGitHub {
    owner = "maliit";
    repo = "framework";
    rev = "ba6f7eda338a913f2c339eada3f0382e04f7dd67";
    hash = "sha256-iwWLnstQMG8F6uE5rKF6t2X43sXQuR/rIho2RN/D9jE=";
  };

  patches = [
    ./2000-Allow-external-wrapper-to-point-to-plugins.patch
  ];

  postPatch = ''
    # Fix doubled prefix
    substituteInPlace src/maliit-plugins.prf.in \
      --replace-fail '@CMAKE_INSTALL_PREFIX@/@CMAKE_INSTALL_LIBDIR@' '@CMAKE_INSTALL_FULL_LIBDIR@' \
      --replace-fail '@CMAKE_INSTALL_PREFIX@/@CMAKE_INSTALL_INCLUDEDIR@' '@CMAKE_INSTALL_FULL_INCLUDEDIR@'
  '';

  buildInputs = [
    at-spi2-atk
    at-spi2-core
    libepoxy
    gtk3
    libdatrie
    libselinux
    libsepol
    libthai
    pcre
    util-linux
    wayland
    xorg.libXdmcp
    xorg.libXtst
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    pkg-config
    wayland-protocols
    wayland-scanner
  ];

  cmakeFlags = [
    (lib.cmakeFeature "QT5_PLUGINS_INSTALL_DIR" "${placeholder "out"}/${qtbase.qtPluginPrefix}")
    (lib.cmakeFeature "QT5_MKSPECS_INSTALL_DIR" "${placeholder "out"}/mkspecs")
  ];

  meta = with lib; {
    description = "Core libraries of Maliit and server";
    mainProgram = "maliit-server";
    homepage = "http://maliit.github.io/";
    license = licenses.lgpl21Plus;
    maintainers = [ ];
  };
}
