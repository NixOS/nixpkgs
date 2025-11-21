{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "cooper";
  version = "1.01-unstable-2025-05-25";

  src = fetchFromGitHub {
    owner = "indestructible-type";
    repo = "Cooper";
    rev = "062a60572254535634569ab23b993a5745bab4ac";
    hash = "sha256-4WaRFvAn32IfeCCDszOsmDxFuKnnADOXj/vj8SZB2mU=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp fonts/*/*.otf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = {
    homepage = "https://indestructibletype.com/Cooper/index.html";
    description = "Cooper* a revival of the Cooper font family by indestructible type*";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ gavink97 ];
  };
}
