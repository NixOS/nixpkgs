{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "bodoni-moda";
  version = "2.4-unstable-2024-02-18";

  src = fetchFromGitHub {
    owner = "indestructible-type";
    repo = "Bodoni";
    rev = "30ce6cdc354ef179a3b72ba0f0e71826e599348c";
    hash = "sha256-OQi+KKBM+BrmA2pDit6dib5krrQBba5dVCBd2/G5sIM=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp fonts/*/*.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = {
    homepage = "https://indestructibletype.com/Bodoni.html";
    description = "Bodoni Moda a modern no-compromises Bodoni family by indestructible type*";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ gavink97 ];
  };
}
