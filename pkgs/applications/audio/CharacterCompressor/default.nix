{ stdenv, fetchFromGitHub, faust2jaqt, faust2lv2gui }:
stdenv.mkDerivation rec {
  name = "CharacterCompressor-${version}";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "CharacterCompressor";
    rev = "v${version}";
    sha256 = "0fvi8m4nshcxypn4jgxhnh7pxp68wshhav3k8wn3il7qpw71pdxi";
  };

  buildInputs = [ faust2jaqt faust2lv2gui ];

  buildPhase = ''
    faust2jaqt -t 99999 CharacterCompressor.dsp
    faust2lv2 -gui -t 99999 CharacterCompressor.dsp
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp CharacterCompressor $out/bin/
    mkdir -p $out/lib/lv2
    cp -r CharacterCompressor.lv2/ $out/lib/lv2
  '';

  meta = {
    description = "A compressor with character. For jack and lv2";
    homepage = https://github.com/magnetophon/CharacterCompressor;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
  };
}
