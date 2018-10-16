{ stdenv, fetchurl, ffmpeg, sox }:

stdenv.mkDerivation rec {
  name = "bs1770gain-${version}";
  version = "0.5.0";

  src = fetchurl {
    url = "mirror://sourceforge/bs1770gain/${name}.tar.gz";
    sha256 = "0vd7320k7s2zcn2vganclxbr1vav18ghld27rcwskvcc3dm8prii";
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
