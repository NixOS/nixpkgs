{
  lib,
  stdenv,
  fetchFromGitHub,
  faust2jaqt,
  faust2lv2,
}:
stdenv.mkDerivation rec {
  pname = "mooSpace";
  version = "unstable-2020-06-10";

  src = fetchFromGitHub {
    owner = "modularev";
    repo = pname;
    rev = "e5440407ea6ef9f7fcca838383b2b9a388c22874";
    sha256 = "10vsbddf6d7i06040850v8xkmqh3bqawczs29kfgakair809wqxl";
  };

  buildInputs = [
    faust2jaqt
    faust2lv2
  ];

  patchPhase = "mv ${pname}_faust.dsp ${pname}.dsp";

  dontWrapQtApps = true;

  buildPhase = ''
    faust2jaqt -time -vec -t 0 ${pname}.dsp
    faust2lv2  -time -vec -t 0 -gui ${pname}.dsp
  '';

  installPhase = ''
    mkdir -p $out/bin
    for f in $(find . -executable -type f); do
      cp $f $out/bin/
    done
    mkdir -p $out/lib/lv2
    cp -r ${pname}.lv2 $out/lib/lv2
  '';

  meta = {
    description = "Variable reverb audio effect, jack and lv2";
    homepage = "https://github.com/modularev/mooSpace";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.magnetophon ];
  };
}
