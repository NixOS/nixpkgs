{ stdenv, fetchFromGitHub, faust2jaqt, faust2lv2gui }:
stdenv.mkDerivation rec {
  name = "CompBus-${version}";
  version = "1.1.02";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "CompBus";
    rev = "v${version}";
    sha256 = "025vi60caxk3j2vxxrgbc59xlyr88vgn7k3127s271zvpyy7apwh";
  };

  buildInputs = [ faust2jaqt faust2lv2gui ];

  buildPhase = ''
    for f in *.dsp;
    do
      faust2jaqt -t 99999 $f
      faust2lv2 -gui -t 99999 $f
    done
  '';

  installPhase = ''
    mkdir -p $out/lib/lv2
    mv *.lv2/ $out/lib/lv2
    mkdir -p $out/bin
    for f in $(find . -executable -type f);
    do
      cp $f $out/bin/
    done
  '';

  meta = {
    description = "A group of compressors mixed into a bus, sidechained from that mix bus. For jack and lv2";
    homepage = https://github.com/magnetophon/CompBus;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
  };
}
