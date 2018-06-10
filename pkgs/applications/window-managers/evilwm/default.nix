{ stdenv, fetchurl,  libX11, libXext, libXrandr, libXrender,
  xproto, xextproto, randrproto, renderproto, kbproto,  patches ? [] }:

stdenv.mkDerivation rec {
  name = "evilwm-1.1.1";

  src = fetchurl {
    url = "http://www.6809.org.uk/evilwm/${name}.tar.gz";
    sha256 = "79589c296a5915ee0bae1d231e8912601fc794d9f0a9cacb6b648ff9a5f2602a";
  };

  buildInputs = [ libX11 libXext libXrandr libXrender
                  xproto xextproto randrproto renderproto kbproto ];

  prePatch = ''substituteInPlace ./Makefile --replace /usr $out \
                                            --replace "CC = gcc" "#CC = gcc"'';

  # Allow users set their own list of patches
  inherit patches;

  meta = with stdenv.lib; {
    homepage = http://www.6809.org.uk/evilwm/;
    description = "Minimalist window manager for the X Window System";

    license = {
      shortName = "evilwm";
      fullName = "Custom, inherited from aewm and 9wm";
      url = http://www.6809.org.uk/evilwm/;
      free = true;
    };  # like BSD/MIT, but Share-Alike'y; See README.

    maintainers = with maintainers; [ amiloradovsky ];
    platforms = platforms.all;
  };
}
