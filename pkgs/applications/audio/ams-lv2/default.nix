{ stdenv, fetchFromGitHub, cairo, fftw, gtkmm2, lv2, lvtk, pkgconfig, python }:

stdenv.mkDerivation  rec {
  name = "ams-lv2-${version}";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "blablack";
    repo = "ams-lv2";
    rev = version;
    sha256 = "1n1dnqnj24xhiy9323lj52nswr5120cj56fpckg802miss05sr6x";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cairo fftw gtkmm2 lv2 lvtk python ];

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
