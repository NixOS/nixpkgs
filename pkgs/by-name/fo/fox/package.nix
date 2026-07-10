{
  lib,
  stdenv,
  fetchurl,
  libpng,
  libjpeg,
  libtiff,
  zlib,
  bzip2,
  mesa_glu,
  libxcursor,
  libxext,
  libxrandr,
  libxft,
  cups,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fox";
  version = "1.7.81";

  src = fetchurl {
    url = "http://fox-toolkit.org/ftp/fox-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-bu+IEqNkv9OAf96dPYre3CP759pjalVIbYyc3QSQW2w=";
  };

  buildInputs = [
    libpng
    libjpeg
    libtiff
    zlib
    bzip2
    mesa_glu
    libxcursor
    libxext
    libxrandr
    libxft
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cups
  ];

  doCheck = true;

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  meta = {
    description = "C++ based class library for building Graphical User Interfaces";
    longDescription = ''
      FOX stands for Free Objects for X.
      It is a C++ based class library for building Graphical User Interfaces.
      Initially, it was developed for LINUX, but the scope of this project has in the course of time become somewhat more ambitious.
      Current aims are to make FOX completely platform independent, and thus programs written against the FOX library will be only a compile away from running on a variety of platforms.
    '';
    homepage = "http://fox-toolkit.org";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
