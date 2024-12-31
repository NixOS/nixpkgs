{
  lib,
  stdenv,
  fetchurl,
  imake,
  gccmakedep,
  libX11,
  libXext,
  libXmu,
}:

stdenv.mkDerivation rec {
  pname = "larswm";
  version = "7.5.3";

  src = fetchurl {
    url = "mirror://sourceforge/larswm/larswm-${version}.tar.gz";
    sha256 = "1xmlx9g1nhklxjrg0wvsya01s4k5b9fphnpl9zdwp29mm484ni3v";
  };

  nativeBuildInputs = [
    imake
    gccmakedep
  ];
  buildInputs = [
    libX11
    libXext
    libXmu
  ];

  makeFlags = [
    "BINDIR=$(out)/bin"
    "MANPATH=$(out)/share/man"
  ];
  installTargets = [
    "install"
    "install.man"
  ];

  meta = {
    homepage = "http://www.fnurt.net/larswm";
    description = "9wm-like tiling window manager";
    license = lib.licenses.free;
    platforms = lib.platforms.linux;
  };
}
