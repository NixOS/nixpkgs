{ stdenv, pkgs, fetchFromGitHub,
automake, pkgconfig, lv2, fftw, cmake, xorg, libjack2, libsamplerate, libsndfile
}:

stdenv.mkDerivation rec {
  repo = "rkrlv2";
  name = "${repo}-b1.0";

  src = fetchFromGitHub {
    owner = "ssj71";
    inherit repo;
    rev = "a315f5aefe63be7e34663596b8b050410a9b7e72";
    sha256 = "0kr3rvq7n1bh47qryyarcpiibms601qd8l1vypmm61969l4d4bn8";
  };

  buildInputs = with xorg; [ automake pkgconfig lv2 fftw cmake libXpm libjack2 libsamplerate libsndfile libXft ];

  meta = {
    description = "Rakarrak effects ported to LV2";
    homepage = https://github.com/ssj71/rkrlv2;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.joelmo ];
    platforms = stdenv.lib.platforms.linux;
  };
}
