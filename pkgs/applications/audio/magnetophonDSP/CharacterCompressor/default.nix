{
  lib,
  stdenv,
  fetchFromGitHub,
  faust2jaqt,
  faust2lv2,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "CharacterCompressor";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "CharacterCompressor";
    rev = "V${finalAttrs.version}";
    hash = "sha256-5VbVWOIoLM9bq4kR69kP5yNnliAIy7ieOWQI0KGEC8A=";
  };

  buildInputs = [
    faust2jaqt
    faust2lv2
  ];

  dontWrapQtApps = true;

  buildPhase = ''
    faust2jaqt -vec -time -t 99999 CharacterCompressor.dsp
    faust2jaqt -vec -time -t 99999 CharacterCompressorMono.dsp
    faust2lv2 -vec -time -gui -t 99999 CharacterCompressor.dsp
    faust2lv2 -vec -time -gui -t 99999 CharacterCompressorMono.dsp
  '';

  installPhase = ''
    mkdir -p $out/bin
    for f in $(find . -executable -type f); do
      cp $f $out/bin/
    done
    mkdir -p $out/lib/lv2
    cp -r CharacterCompressor.lv2/ $out/lib/lv2
    cp -r CharacterCompressorMono.lv2/ $out/lib/lv2
  '';

  meta = {
    description = "Compressor with character. For jack and lv2";
    homepage = "https://github.com/magnetophon/CharacterCompressor";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.magnetophon ];
  };
})
