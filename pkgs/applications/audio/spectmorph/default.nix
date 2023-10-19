{ lib, stdenv, fetchurl, pkg-config, libjack2, lv2, glib, qt5, libao, cairo, libsndfile, fftwFloat }:

stdenv.mkDerivation rec {
  pname = "spectmorph";
  version = "0.5.2";
  src = fetchurl {
    url = "https://spectmorph.org/files/releases/${pname}-${version}.tar.bz2";
    sha256 = "0yrq7mknhk096wfsx0q3b6wwa2w5la0rxa113di26rrrw136xl1f";
  };

  buildInputs = [  libjack2 lv2 glib qt5.qtbase libao cairo libsndfile fftwFloat ];

  nativeBuildInputs = [ pkg-config ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Allows to analyze samples of musical instruments, and to combine them (morphing) to construct hybrid sounds";
    homepage = "https://spectmorph.org";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = [ maintainers.magnetophon ];
  };
}
