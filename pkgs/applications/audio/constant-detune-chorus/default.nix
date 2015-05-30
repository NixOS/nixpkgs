{ stdenv, fetchFromGitHub, faust2jack, faust2lv2 }:
stdenv.mkDerivation rec {
  name = "constant-detune-chorus-${version}";
  version = "0.1.01";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "constant-detune-chorus";
    rev = "v${version}";
    sha256 = "1z8aj1a36ix9jizk9wl06b3i98hrkg47qxqp8vx930r624pc5z86";
  };

  buildInputs = [ faust2jack faust2lv2 ];

  buildPhase = ''
    faust2jack -t 99999 constant-detune-chorus.dsp
    faust2lv2 -t 99999 constant-detune-chorus.dsp
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp constant-detune-chorus $out/bin/
    mkdir -p $out/lib/lv2
    cp -r constant-detune-chorus.lv2/ $out/lib/lv2
  '';

  meta = {
    description = "A chorus algorithm that maintains constant and symmetric detuning depth (in cents), regardless of modulation rate. For jack and lv2";
    homepage = https://github.com/magnetophon/constant-detune-chorus;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
  };
}
