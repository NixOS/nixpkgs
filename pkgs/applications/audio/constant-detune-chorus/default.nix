{ stdenv, fetchFromGitHub, faust2jaqt, faust2lv2gui }:
stdenv.mkDerivation rec {
  name = "constant-detune-chorus-${version}";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "constant-detune-chorus";
    rev = "v${version}";
    sha256 = "1ks2k6pflqyi2cs26bnbypphyrrgn0xf31l31kgx1qlilyc57vln";
  };

  buildInputs = [ faust2jaqt faust2lv2gui ];

  buildPhase = ''
    faust2jaqt -t 99999 ConstantDetuneChorus.dsp
    faust2lv2 -gui -t 99999 ConstantDetuneChorus.dsp
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
