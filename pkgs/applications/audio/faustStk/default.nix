{ stdenv, lib, fetchFromGitHub, faust2jaqt, faust2lv2 }:

stdenv.mkDerivation rec {
  pname = "faustPhhysicalModeling";
  version = "2.20.2";

  src = fetchFromGitHub {
    owner = "grame-cncm";
    repo = "faust";
    rev = version;
    sha256 = "1mm93ba26b7q69hvabzalg30dh8pl858nj4m2bb57pznnp09lq9a";
  };

  buildInputs = [ faust2jaqt faust2lv2 ];

  buildPhase = ''
    cd examples/physicalModeling/faust-stk

    for f in *.dsp; do
      faust2jaqt -time -vec  -midi -nvoices 8 -t 99999 $f
      faust2lv2  -time -vec -double -gui -nvoices 32 -t 99999 $f
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
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "The physical modeling instruments included with faust, compiled as jack standalone and lv2 instruments";
    homepage = "https://ccrma.stanford.edu/~rmichon/faustSTK/";
    license = licenses.stk;
    platforms = platforms.linux;
    maintainers = with maintainers; [ magnetophon ];
  };
}
