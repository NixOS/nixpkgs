{
  lib,
  stdenv,
  fetchFromGitHub,
  faust2jaqt,
  faust2lv2,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "constant-detune-chorus";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "constant-detune-chorus";
    rev = "V${finalAttrs.version}";
    hash = "sha256-dnk0N2ZjaVtL2GHCzf/Xbzr+RTQe5NBxP/xkVwSrN+o=";
  };

  buildInputs = [
    faust2jaqt
    faust2lv2
  ];

  dontWrapQtApps = true;

  buildPhase = ''
    faust2jaqt -time -vec -t 99999 ConstantDetuneChorus.dsp
    faust2lv2  -time -vec -t 99999 -gui ConstantDetuneChorus.dsp
  '';

  installPhase = ''
    mkdir -p $out/bin
    for f in $(find . -executable -type f); do
      cp $f $out/bin/
    done
    mkdir -p $out/lib/lv2
    cp -r ConstantDetuneChorus.lv2/ $out/lib/lv2
  '';

  meta = {
    description = "Chorus algorithm that maintains constant and symmetric detuning depth (in cents), regardless of modulation rate. For jack and lv2";
    homepage = "https://github.com/magnetophon/constant-detune-chorus";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.magnetophon ];
  };
})
