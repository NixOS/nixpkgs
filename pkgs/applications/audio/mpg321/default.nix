{stdenv, fetchurl, libao, libmad, libid3tag, zlib}:

stdenv.mkDerivation rec {
  name = "mpg321-0.2.13-2";

  src = fetchurl {
    url = "mirror://sourceforge/mpg321/0.2.13/${name}.tar.gz";
    sha256 = "0zx9xyr97frlyrwyk2msm9h1sn2b84vqaxcy5drbzcd2n585lwlx";
  };

  buildInputs = [libao libid3tag libmad zlib];

  meta = {
    description = "mpg321, a command-line MP3 player";
    homepage = http://mpg321.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ ];
    platforms = stdenv.lib.platforms.gnu;
  };
}
