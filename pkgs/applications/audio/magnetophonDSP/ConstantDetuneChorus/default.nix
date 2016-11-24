{ stdenv, fetchFromGitHub, faust2jaqt, faust2lv2 }:
stdenv.mkDerivation rec {
  name = "constant-detune-chorus-${version}";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "constant-detune-chorus";
    rev = "V${version}";
    sha256 = "1sipmc25fr7w7xqx1r0y6i2zwfkgszzwvhk1v15mnsb3cqvk8ybn";
  };

  buildInputs = [ faust2jaqt faust2lv2 ];

  buildPhase = ''
    faust2jaqt -time -vec -t 99999 ConstantDetuneChorus.dsp
    sed -i "s|\[ *scale *: *log *\]||g ; s|\btgroup\b|hgroup|g" "ConstantDetuneChorus.dsp"
    faust2lv2  -time -vec -t 99999 -gui ConstantDetuneChorus.dsp
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ConstantDetuneChorus $out/bin/
    mkdir -p $out/lib/lv2
    cp -r ConstantDetuneChorus.lv2/ $out/lib/lv2
  '';

  meta = {
    description = "A chorus algorithm that maintains constant and symmetric detuning depth (in cents), regardless of modulation rate. For jack and lv2";
    homepage = https://github.com/magnetophon/constant-detune-chorus;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
  };
}
