{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "drafting-mono";
  version = "1.1-unstable-2024-06-04";

  src = fetchFromGitHub {
    owner = "indestructible-type";
    repo = "Drafting";
    rev = "c387df13576c3b541352725b021f9f99302e52d6";
    hash = "sha256-J64mmDOzTV4MRuZO3MB2SSX5agCRjLDjXAPXuDfdlOM=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp fonts/*/*.otf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = {
    homepage = "https://indestructibletype.com/Drafting/";
    description = "Drafting* Mono a mixed serif typewriter inspired font by indestructible type*";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ gavink97 ];
  };
}
