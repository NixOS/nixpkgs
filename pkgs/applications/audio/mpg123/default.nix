{stdenv, fetchurl, alsaLib }:

stdenv.mkDerivation {
  name = "mpg123-1.12.3";

  src = fetchurl {
    url = mirror://sourceforge/mpg123/mpg123-1.12.3.tar.bz2;
    sha256 = "1ij689s7jch3d4g0ja3jylaphallc8vgrsrm9b12254phnyy23xf";
  };

  buildInputs = [ alsaLib ];

  crossAttrs = {
    configureFlags = if stdenv.cross ? mpg123 then
      "--with-cpu=${stdenv.cross.mpg123.cpu}" else "";
  };

  meta = {
    description = "Command-line MP3 player";
    homepage = http://mpg123.sourceforge.net/;
    license = "LGPL";
  };
}
