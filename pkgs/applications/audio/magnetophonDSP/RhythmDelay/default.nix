{
  lib,
  stdenv,
  fetchFromGitHub,
  faust2jaqt,
  faust2lv2,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "RhythmDelay";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "RhythmDelay";
    rev = "V${finalAttrs.version}";
    hash = "sha256-5HUHfBIns33LhlARXUx7Xfez3Wk4rswya4P8pxKVC8g=";
  };

  buildInputs = [
    faust2jaqt
    faust2lv2
  ];

  dontWrapQtApps = true;

  buildPhase = ''
    faust2jaqt -time -vec -t 99999 RhythmDelay.dsp
    faust2lv2  -time -vec -t 99999 -gui RhythmDelay.dsp
  '';

  installPhase = ''
    mkdir -p $out/bin
    for f in $(find . -executable -type f); do
      cp $f $out/bin/
    done
    mkdir -p $out/lib/lv2
    cp -r RhythmDelay.lv2/ $out/lib/lv2
  '';

  meta = {
    description = "Tap a rhythm into your delay! For jack and lv2";
    homepage = "https://github.com/magnetophon/RhythmDelay";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.magnetophon ];
  };
})
