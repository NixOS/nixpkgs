{ stdenv, fetchurl, pkgconfig, libjack2, lv2, glib, qt5, libao, cairo, libsndfile, fftwFloat }:

stdenv.mkDerivation rec {
  name = "spectmorph-${version}";
  version = "0.4.1";
  src = fetchurl {
    url = "http://spectmorph.org/files/releases/${name}.tar.bz2";
    sha256 = "0z00yvv3jl8qsx6bz9msmg09mdnj5r5d4ws5bmnylwxk182whbrv";
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
