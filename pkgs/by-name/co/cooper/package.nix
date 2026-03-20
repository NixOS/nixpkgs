{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
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

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "https://indestructibletype.com/Cooper/index.html";
    description = "Cooper* a revival of the Cooper font family by indestructible type*";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ gavink97 ];
  };
}
