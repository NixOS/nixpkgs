{ mkDerivation
, lib
, fetchFromGitHub
, fetchpatch

, at-spi2-atk
, at-spi2-core
, libepoxy
, gtk3
, libdatrie
, libselinux
, libsepol
, libthai
, pcre
, util-linux
, wayland
, xorg

, cmake
, doxygen
, pkg-config
, wayland-protocols
}:

mkDerivation rec {
  pname = "maliit-framework";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "maliit";
    repo = "framework";
    rev = "refs/tags/${version}";
    sha256 = "sha256-q+hiupwlA0PfG+xtomCUp2zv6HQrGgmOd9CU193ucrY=";
  };

  patches = [
    # FIXME: backport GCC 12 build fix, remove for next release
    (fetchpatch {
      url = "https://github.com/maliit/framework/commit/86e55980e3025678882cb9c4c78614f86cdc1f04.diff";
      hash = "sha256-5R+sCI05vJX5epu6hcDSWWzlZ8ns1wKEJ+u8xC6d8Xo=";
    })
  ];

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
    pkg-config
    wayland-protocols
  ];

  preConfigure = ''
    cmakeFlags+="-DQT5_PLUGINS_INSTALL_DIR=$out/$qtPluginPrefix"
  '';

  meta = with lib; {
    description = "Core libraries of Maliit and server";
    mainProgram = "maliit-server";
    homepage = "http://maliit.github.io/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
  };
}
