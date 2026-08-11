{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "drafting-mono";
  version = "1.1-unstable-2024-06-04";

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchFromGitHub {
    owner = "indestructible-type";
    repo = "Drafting";
    rev = "c387df13576c3b541352725b021f9f99302e52d6";
    hash = "sha256-J64mmDOzTV4MRuZO3MB2SSX5agCRjLDjXAPXuDfdlOM=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "https://indestructibletype.com/Drafting/";
    description = "Drafting* Mono a mixed serif typewriter inspired font by indestructible type*";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ gavink97 ];
  };
}
