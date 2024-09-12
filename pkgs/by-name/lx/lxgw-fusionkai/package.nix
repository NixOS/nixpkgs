{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  pname = "lxgw-fusionkai";
  version = "24.134";

  src = fetchFromGitHub {
    owner = "lxgw";
    repo = "FusionKai";
    rev = "v${version}";
    hash = "sha256-pEISoFEsv8SJOGa2ud/nV1yvl8T9kakfKENu3mfYA5A=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/lxgw/FusionKai";
    description = "Simplified Chinese font derived from LXGW WenKai GB, iansui and Klee One";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ hellodword ];
  };
}
