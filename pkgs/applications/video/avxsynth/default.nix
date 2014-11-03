{ stdenv, fetchurl, ffmpeg, autoconf, automake, libtool, pkgconfig, log4cpp
, pango, cairo, python, libjpeg, ffms
, enableQt ? true, qt4}:

stdenv.mkDerivation rec {
  name = "avxsynth-4.0-e153e672bf";

  src = fetchurl {
    url = https://github.com/avxsynth/avxsynth/tarball/e153e672bf;
    name = "${name}.tar.gz";
    sha256 = "16l2ld8k1nfsms6jd9d9r4l247xxbncsak66w87icr20yzyhs14s";
  };

  buildInputs = [ ffmpeg autoconf automake libtool pkgconfig log4cpp pango cairo python
    libjpeg ffms ]
    ++ stdenv.lib.optional enableQt qt4;

  preConfigure = "autoreconf -vfi";

  meta = {
    homepage = https://github.com/avxsynth/avxsynth/wiki;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
