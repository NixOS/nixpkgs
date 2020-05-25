{ stdenv, fetchFromGitHub,
automake, pkgconfig, lv2, fftw, cmake, xorg, libjack2, libsamplerate, libsndfile
}:

stdenv.mkDerivation rec {
  repo = "rkrlv2";
  name = "${repo}-b2.0";

  src = fetchFromGitHub {
    owner = "ssj71";
    inherit repo;
    rev = "beta_2";
    sha256 = "128jcilbrd1l65c01w2bazsb21x78mng0jjkhi3x9crf1n9qbh2m";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = with xorg; [ automake lv2 fftw cmake libXpm libjack2 libsamplerate libsndfile libXft ];

  meta = {
    description = "Rakarrak effects ported to LV2";
    homepage = "https://github.com/ssj71/rkrlv2";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.joelmo ];
    platforms = stdenv.lib.platforms.linux;
  };
}
