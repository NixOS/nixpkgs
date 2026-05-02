{
  lib,
  stdenv,
  fetchurl,
  libx11,
  libxext,
  libxrandr,
  libxrender,
  xorgproto,
  config,
  patches ? [ ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "evilwm";
  version = "1.4.3";

  src = fetchurl {
    url = "https://www.6809.org.uk/evilwm/evilwm-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-1ZRbILEskdskEvrA29o/ucPsjeu44bEJg4mSsrG75dQ=";
  };

  patches = (config.evilwm.patches or [ ]) ++ patches;

  buildInputs = [
    libx11
    libxext
    libxrandr
    libxrender
    xorgproto
  ];

  postPatch = ''
    substituteInPlace ./Makefile \
      --replace /usr $out \
      --replace "CC = gcc" "#CC = gcc"
  '';

  meta = {
    homepage = "http://www.6809.org.uk/evilwm/";
    description = "Minimalist window manager for the X Window System";
    license = {
      shortName = "evilwm";
      fullName = "Custom, inherited from aewm and 9wm";
      url = "https://www.6809.org.uk/evilwm/";
      free = true;
    }; # like BSD/MIT, but Share-Alike'y; See README.
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "evilwm";
  };
})
