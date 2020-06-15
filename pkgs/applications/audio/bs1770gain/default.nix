{ stdenv, fetchurl, ffmpeg_3, sox }:

stdenv.mkDerivation rec {
  pname = "bs1770gain";
  version = "0.7.0";

  src = fetchurl {
    url = "mirror://sourceforge/bs1770gain/${pname}-${version}.tar.gz";
    sha256 = "0a2dcaxvxy5m3a5sb1lhplsymvz3ypaiidc5xn9qy01h53zvyvkp";
  };

  buildInputs = [ ffmpeg_3 sox ];

  NIX_CFLAGS_COMPILE = "-Wno-error";

  meta = with stdenv.lib; {
    description = "A audio/video loudness scanner implementing ITU-R BS.1770";
    license = licenses.gpl2Plus;
    homepage = "http://bs1770gain.sourceforge.net/";
    platforms = platforms.all;
  };
}
