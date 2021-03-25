{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, libX11, libXrandr, libXinerama, libXext, libXcursor, freetype, alsaLib, libjack2 }:

stdenv.mkDerivation rec {
  pname = "stochas";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = pname;
    rev = "v${version}";
    sha256 = "0b26mbj727dnygavz4kihnhmnnvwsr9l145w6kydq7bd7nwiw7lq";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    libX11 libXrandr libXinerama libXext libXcursor freetype alsaLib libjack2
  ];

  installPhase = ''
    mkdir -p $out/lib/vst3
    cp -r stochas_artefacts/Release/VST3/Stochas.vst3 $out/lib/vst3
  '';

  meta = with lib; {
    description = "Probabilistic polyrhythmic sequencer plugin";
    homepage = "https://stochas.org/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ magnetophon ];
    platforms = platforms.unix;
  };
}
