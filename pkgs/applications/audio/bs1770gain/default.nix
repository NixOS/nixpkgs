{ stdenv, fetchurl, ffmpeg, sox }:

stdenv.mkDerivation rec {
  name = "bs1770gain-${version}";
  version = "0.5.1";

  src = fetchurl {
    url = "mirror://sourceforge/bs1770gain/${name}.tar.gz";
    sha256 = "0r4fbajgfmnwgl63hcm56f1j8m5f135q6j5jkzdvrrhpcj39yx06";
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
