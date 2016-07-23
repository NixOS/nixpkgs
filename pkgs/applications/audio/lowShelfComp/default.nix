{ stdenv, fetchFromGitHub, faust2jaqt, faust2lv2gui }:
stdenv.mkDerivation rec {
  name = "lowShelfComp-${version}";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "lowShelfComp";
    rev = "V${version}";
    sha256 = "0ip1rbvi91psvxvw49d90ljvhbh0b0lsjlpn0shp6w6if8izrlgv";
  };

  buildInputs = [ faust2jaqt faust2lv2gui ];

  buildPhase = ''
    faust2jaqt -vec -time -t 99999 lowShelfComp.dsp
    faust2lv2 -vec -time -gui -t 99999 lowShelfComp.dsp
    faust2jaqt -vec -time -t 99999 lowShelfCompMono.dsp
    faust2lv2 -vec -time -gui -t 99999 lowShelfCompMono.dsp
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
