{ stdenv, lib, fetchFromGitHub, faust2jaqt, faust2lv2 }:
stdenv.mkDerivation rec {
  pname = "faustPhysicalModeling";
  version = "2.69.3";

  src = fetchFromGitHub {
    owner = "grame-cncm";
    repo = "faust";
    rev = version;
    sha256 = "sha256-E7cHDeQV7NVKyoCgI8P3gennpBidk7JmdnFGSIulvvQ=";
  };

  buildInputs = [ faust2jaqt faust2lv2 ];

  dontWrapQtApps = true;

  buildPhase = ''
    cd examples/physicalModeling

    for f in *MIDI.dsp; do
      faust2jaqt -time -vec -double -midi -nvoices 16 -t 99999 $f
      faust2lv2  -time -vec -double -gui -nvoices 16 -t 99999 $f
    done
  '';

  installPhase = ''
    mkdir -p $out/lib/lv2 $out/bin
    mv *.lv2/ $out/lib/lv2
    for f in $(find . -executable -type f); do
      cp $f $out/bin/
    done
  '';

  meta = with lib; {
    description = "The physical models included with faust compiled as jack standalone and lv2 instruments";
    homepage = "https://github.com/grame-cncm/faust/tree/master-dev/examples/physicalModeling";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ magnetophon ];
  };
}
