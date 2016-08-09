{ stdenv, fetchFromGitHub, faust2jaqt, faust2lv2gui }:
stdenv.mkDerivation rec {
  name = "CharacterCompressor-${version}";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "CharacterCompressor";
    rev = "V${version}";
    sha256 = "0ci27v5k10prsmcd0g6q5vhr31mz8hsmrsdk436vfbcv3s108rcc";
  };

  buildInputs = [ faust2jaqt faust2lv2gui ];

  buildPhase = ''
    faust2jaqt -vec -time -t 99999 CharacterCompressor.dsp
    faust2lv2 -vec -time -gui -t 99999 CharacterCompressor.dsp
    faust2jaqt -vec -time -t 99999 CharacterCompressorMono.dsp
    faust2lv2 -vec -time -gui -t 99999 CharacterCompressorMono.dsp
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp CharacterCompressor $out/bin/
    cp CharacterCompressorMono $out/bin/
    mkdir -p $out/lib/lv2
    cp -r CharacterCompressor.lv2/ $out/lib/lv2
    cp -r CharacterCompressorMono.lv2/ $out/lib/lv2
  '';

  meta = {
    description = "A compressor with character. For jack and lv2";
    homepage = https://github.com/magnetophon/CharacterCompressor;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
  };
}
