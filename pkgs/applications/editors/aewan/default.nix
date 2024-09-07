{ lib, gccStdenv, fetchurl, fetchpatch, zlib, ncurses }:

let stdenv = gccStdenv;
in
stdenv.mkDerivation rec {
  pname = "aewan";
  version = "1.0.01";

  src = fetchurl {
    url = "mirror://sourceforge/aewan/${pname}-${version}.tar.gz";
    sha256 = "5266dec5e185e530b792522821c97dfa5f9e3892d0dca5e881d0c30ceac21817";
  };

  patches = [
    # Pull patch pending upstream inclusion:
    #  https://sourceforge.net/p/aewan/bugs/13/
    (fetchpatch {
      url = "https://sourceforge.net/p/aewan/bugs/13/attachment/aewan-cvs-ncurses-6.3.patch";
      sha256 = "0pgpk1l3d6d5y37lvvavipwnmv9gmpfdy21jkz6baxhlkgf43r4p";
      # patch is in CVS diff format, add 'a/' prefix
      extraPrefix = "";
    })
  ];

  buildInputs = [ zlib ncurses ];

  meta = {
    description = "Ascii-art Editor Without A Name";
    homepage = "https://aewan.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
}
