{ stdenv, fetchurl, ffmpeg, sox }:

stdenv.mkDerivation rec {
  name = "bs1770gain-${version}";
  version = "0.4.7";

  src = fetchurl {
    url = "mirror://sourceforge/bs1770gain/${name}.tar.gz";
    sha256 = "0dnypm7k4axc693g0z73n2mvycbzgc4lnj2am64xjzyg37my4qzz";
  };

  buildInputs = [ ffmpeg sox ];

  NIX_CFLAGS_COMPILE = "-Wno-error";

  meta = {
    description = "A audio/video loudness scanner implementing ITU-R BS.1770";
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = "http://bs1770gain.sourceforge.net/";
    platforms = stdenv.lib.platforms.all;
  };
}
