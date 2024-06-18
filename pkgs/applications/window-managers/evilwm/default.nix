{ lib
, stdenv
, fetchurl
, libX11
, libXext
, libXrandr
, libXrender
, xorgproto
, patches ? [ ]
}:

stdenv.mkDerivation rec {
  pname = "evilwm";
  version = "1.4.3";

  src = fetchurl {
    url = "http://www.6809.org.uk/evilwm/evilwm-${version}.tar.gz";
    sha256 = "sha256-1ZRbILEskdskEvrA29o/ucPsjeu44bEJg4mSsrG75dQ=";
  };

  buildInputs = [
    libX11
    libXext
    libXrandr
    libXrender
    xorgproto
  ];

  postPatch = ''
    substituteInPlace ./Makefile \
      --replace /usr $out \
      --replace "CC = gcc" "#CC = gcc"
  '';

  # Allow users set their own list of patches
  inherit patches;

  meta = with lib; {
    homepage = "http://www.6809.org.uk/evilwm/";
    description = "Minimalist window manager for the X Window System";
    license = {
      shortName = "evilwm";
      fullName = "Custom, inherited from aewm and 9wm";
      url = "http://www.6809.org.uk/evilwm/";
      free = true;
    }; # like BSD/MIT, but Share-Alike'y; See README.
    maintainers = with maintainers; [ amiloradovsky ];
    platforms = platforms.all;
    mainProgram = "evilwm";
  };
}
