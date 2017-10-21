{ stdenv, fetchurl, zlib, ncurses }:

stdenv.mkDerivation rec {
  name = "aewan-${version}";
  version = "1.0.01";

  src = fetchurl {
    url = "mirror://sourceforge/aewan/${name}.tar.gz";
    sha256 = "5266dec5e185e530b792522821c97dfa5f9e3892d0dca5e881d0c30ceac21817";
  };

  buildInputs = [ zlib ncurses ];

  meta = {
    description = "Ascii-art Editor Without A Name";
    homepage = http://aewan.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
