{ stdenv, fetchurl, cairo, fftw, gtkmm2, lv2, lvtk, pkgconfig, python }:

stdenv.mkDerivation  rec {
  name = "ams-lv2-${version}";
  version = "1.1.0";

  src = fetchurl {
    url = "https://github.com/blablack/ams-lv2/archive/v${version}.tar.gz";
    sha256 = "1kqbl7rc3zrs27c5ga0frw3mlpx15sbxzhf04sfbrd9l60535fd5";
  };

  buildInputs = [ cairo fftw gtkmm2 lv2 lvtk pkgconfig python ];

  configurePhase = "python waf configure --prefix=$out";

  buildPhase = "python waf";

  installPhase = "python waf install";

  meta = with stdenv.lib; {
    description = "An LV2 port of the internal modules found in Alsa Modular Synth";
    homepage = http://objectivewave.wordpress.com/ams-lv2;
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
