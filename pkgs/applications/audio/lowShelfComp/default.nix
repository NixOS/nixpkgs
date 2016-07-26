{ stdenv, fetchFromGitHub, faust2jaqt, faust2lv2gui }:
stdenv.mkDerivation rec {
  name = "lowShelfComp-${version}";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "lowShelfComp";
    rev = "V${version}";
    sha256 = "0ap81h0aj7nqpsfsy3m7fnrx8i8msjlv7v4ywqalnbjw0q4bixri";
  };

  buildInputs = [ faust2jaqt faust2lv2gui ];

  buildPhase = ''
    faust2jaqt -vec -double -time -t 99999 lowShelfComp.dsp
    faust2lv2 -vec -double -time -gui -t 99999 lowShelfComp.dsp
    faust2jaqt -vec -double -time -t 99999 lowShelfCompMono.dsp
    faust2lv2 -vec -double -time -gui -t 99999 lowShelfCompMono.dsp
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp lowShelfComp $out/bin/
    cp lowShelfCompMono $out/bin/
    mkdir -p $out/lib/lv2
    cp -r lowShelfComp.lv2/ $out/lib/lv2
    cp -r lowShelfCompMono.lv2/ $out/lib/lv2
  '';

  meta = {
    description = "A multiband compressor made from shelving filters.";
    homepage = https://github.com/magnetophon/lowShelfComp;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
  };
}
