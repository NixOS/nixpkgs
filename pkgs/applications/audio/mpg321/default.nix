{stdenv, fetchurl, libao, libmad, libid3tag, zlib}:

stdenv.mkDerivation {
  name = "mpg321-0.2.10";
  src = fetchurl {
    url = mirror://sourceforge/mpg321/mpg321-0.2.10.tar.gz;
    sha256 = "db0c299592b8f1f704f41bd3fc3a2bf138658108588d51af61638c551af1b0d4";
  };

  buildInputs = [libao libid3tag libmad zlib];

  meta = {
    description = "Command-line MP3 player.";
    homepage = http://mpg321.sourceforge.net/;
    license = "GPLv2";
  };
}
