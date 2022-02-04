{ lib, stdenv, fetchFromGitHub, lv2, libX11, libGL, libGLU, mesa, cmake }:

stdenv.mkDerivation rec {
  pname = "aether-lv2";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "Dougal-s";
    repo = "aether";
    rev = "v${version}";
    sha256 = "0xhih4smjxn87s0f4gaab51d8594qlp0lyypzxl5lm37j1i9zigs";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    lv2 libX11 libGL libGLU mesa
  ];

  installPhase = ''
    mkdir -p $out/lib/lv2
    cp -r aether.lv2 $out/lib/lv2
  '';

  meta = with lib; {
    homepage = "https://dougal-s.github.io/Aether/";
    description = "An algorithmic reverb LV2 based on Cloudseed";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
