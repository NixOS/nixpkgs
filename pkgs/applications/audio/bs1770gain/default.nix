{ stdenv, fetchurl, ffmpeg, sox }:

stdenv.mkDerivation rec {
  pname = "bs1770gain";
  version = "0.6.5";

  src = fetchurl {
    url = "mirror://sourceforge/bs1770gain/${pname}-${version}.tar.gz";
    sha256 = "15nvlh9bg0a52cpg2mii17mlzmxszwivjjalbb4np1v5nj8l5fk6";
  };

  buildInputs = [ ffmpeg sox ];

  NIX_CFLAGS_COMPILE = "-Wno-error";

  meta = with stdenv.lib; {
    description = "A audio/video loudness scanner implementing ITU-R BS.1770";
    license = licenses.gpl2Plus;
    homepage = http://bs1770gain.sourceforge.net/;
    platforms = platforms.all;
  };
}
