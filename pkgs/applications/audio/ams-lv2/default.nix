{ stdenv, fetchFromGitHub, cairo, fftw, gtkmm2, lv2, lvtk, pkgconfig, python3
, wafHook }:

stdenv.mkDerivation  rec {
  name = "ams-lv2-${version}";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "blablack";
    repo = "ams-lv2";
    rev = version;
    sha256 = "1n1dnqnj24xhiy9323lj52nswr5120cj56fpckg802miss05sr6x";
  };

  nativeBuildInputs = [ pkgconfig wafHook ];
  buildInputs = [ cairo fftw gtkmm2 lv2 lvtk ];

  meta = with stdenv.lib; {
    description = "An LV2 port of the internal modules found in Alsa Modular Synth";
    homepage = http://objectivewave.wordpress.com/ams-lv2;
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
    # Build uses `-msse` and `-mfpmath=sse`
    badPlatforms = [ "aarch64-linux" ];
  };
}
