{ stdenv, fetchurl, ffmpeg_3, sox }:

stdenv.mkDerivation rec {
  pname = "bs1770gain";
  version = "0.5.2";

  src = fetchurl {
    url = "mirror://sourceforge/bs1770gain/${pname}-${version}.tar.gz";
    sha256 = "1p6yz5q7czyf9ard65sp4kawdlkg40cfscr3b24znymmhs3p7rbk";
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
