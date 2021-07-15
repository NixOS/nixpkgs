{ mkDerivation
, lib
, fetchFromGitHub

, at-spi2-atk
, at-spi2-core
, epoxy
, gtk3
, libdatrie
, libselinux
, libsepol
, libthai
, pcre
, util-linux
, wayland
, xlibs

, cmake
, doxygen
, pkgconfig
, wayland-protocols
}:

mkDerivation rec {
  pname = "maliit-framework";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "maliit";
    repo = "framework";
    rev = version;
    sha256 = "138jyvw130kmrldksbk4l38gvvahh3x51zi4vyplad0z5nxmbazb";
  };

  buildInputs = [
    at-spi2-atk
    at-spi2-core
    epoxy
    gtk3
    libdatrie
    libselinux
    libsepol
    libthai
    pcre
    util-linux
    wayland
    xlibs.libXdmcp
    xlibs.libXtst
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    pkgconfig
    wayland-protocols
  ];

  preConfigure = ''
    cmakeFlags+="-DQT5_PLUGINS_INSTALL_DIR=$out/$qtPluginPrefix"
  '';

  meta = with lib; {
    description = "Core libraries of Maliit and server";
    homepage = "http://maliit.github.io/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ samueldr ];
  };
}
