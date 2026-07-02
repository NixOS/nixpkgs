{
  lib,
  stdenv,
  fetchurl,
  imake,
  gccmakedep,
  libx11,
  libxext,
  libxmu,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "larswm";
  version = "7.5.3";

  src = fetchurl {
    url = "mirror://sourceforge/larswm/larswm-${finalAttrs.version}.tar.gz";
    sha256 = "1xmlx9g1nhklxjrg0wvsya01s4k5b9fphnpl9zdwp29mm484ni3v";
  };

  nativeBuildInputs = [
    imake
    gccmakedep
  ];
  buildInputs = [
    libx11
    libxext
    libxmu
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
})
