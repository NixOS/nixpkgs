{
  lib,
  stdenv,
  fetchFromGitHub,
  faust2jaqt,
  faust2lv2,
}:
stdenv.mkDerivation {
  pname = "moospace";
  version = "0-unstable-2020-06-10";

  src = fetchFromGitHub {
    owner = "modularev";
    repo = "mooSpace";
    rev = "e5440407ea6ef9f7fcca838383b2b9a388c22874";
    hash = "sha256-tGOeAMpRTfXcTEJ/xhVeA+I6O9qgIECAAfE041pbeoM=";
  };

  buildInputs = [
    faust2jaqt
    faust2lv2
  ];

  patchPhase = "mv mooSpace_faust.dsp mooSpace.dsp";

  dontWrapQtApps = true;

  buildPhase = ''
    faust2jaqt -time -vec -t 0 mooSpace.dsp
    faust2lv2  -time -vec -t 0 -gui mooSpace.dsp
  '';

  installPhase = ''
    mkdir -p $out/bin
    for f in $(find . -executable -type f); do
      cp $f $out/bin/
    done
    mkdir -p $out/lib/lv2
    cp -r mooSpace.lv2 $out/lib/lv2
  '';

  meta = {
    description = "Variable reverb audio effect, jack and lv2";
    homepage = "https://github.com/modularev/mooSpace";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.magnetophon ];
  };
}
