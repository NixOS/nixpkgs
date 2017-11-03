{ stdenv, fetchurl, ffmpeg, sox }:

stdenv.mkDerivation rec {
  name = "bs1770gain-${version}";
  version = "0.4.12";

  src = fetchurl {
    url = "mirror://sourceforge/bs1770gain/${name}.tar.gz";
    sha256 = "0n9skdap1vnl6w52fx0gsrjlk7w3xgdwi62ycyf96h29rx059z6a";
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
