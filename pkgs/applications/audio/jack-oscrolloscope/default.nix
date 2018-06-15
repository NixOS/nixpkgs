{ stdenv, fetchurl, SDL, libjack2, libGLU_combined, pkgconfig }:

stdenv.mkDerivation rec {
  name = "jack_oscrolloscope-${version}";
  version = "0.7";

  src = fetchurl {
    url = "http://das.nasophon.de/download/${name}.tar.gz";
    sha256 = "1pl55in0sj7h5r06n1v91im7d18pplvhbjhjm1fdl39zwnyxiash";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ SDL libjack2 libGLU_combined ];

  installPhase = ''
    mkdir -p $out/bin
    mv jack_oscrolloscope $out/bin/
  '';

  meta = with stdenv.lib; { 
    description = "A simple waveform viewer for JACK";
    homepage = http://das.nasophon.de/jack_oscrolloscope;
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = stdenv.lib.platforms.linux;
  };
}
