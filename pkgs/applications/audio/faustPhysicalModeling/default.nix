{ stdenv, lib, fetchFromGitHub, faust2jaqt, faust2lv2 }:
stdenv.mkDerivation rec {
  pname = "faustPhysicalModeling";
  version = "2.20.2";

  src = fetchFromGitHub {
    owner = "grame-cncm";
    repo = "faust";
    rev = version;
    sha256 = "1mm93ba26b7q69hvabzalg30dh8pl858nj4m2bb57pznnp09lq9a";
  };

  buildInputs = [ faust2jaqt faust2lv2 ];

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
