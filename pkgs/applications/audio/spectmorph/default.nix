{ stdenv, fetchurl, pkgconfig, libjack2, lv2, glib, qt5, libao, cairo, libsndfile, fftwFloat }:

stdenv.mkDerivation rec {
  pname = "spectmorph";
  version = "0.5.0";
  src = fetchurl {
    url = "http://spectmorph.org/files/releases/${pname}-${version}.tar.bz2";
    sha256 = "003wznv3sy1b4g55vqii9pr3i3bb3zmj7nqvwrz7vjsfn2xyd1bn";
  };

  buildInputs = [  libjack2 lv2 glib qt5.qtbase libao cairo libsndfile fftwFloat ];

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "Allows to analyze samples of musical instruments, and to combine them (morphing) to construct hybrid sounds";
    homepage = http://spectmorph.org;
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = [ maintainers.magnetophon ];
  };
}
