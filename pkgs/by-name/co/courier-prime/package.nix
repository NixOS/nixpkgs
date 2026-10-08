{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "courier-prime";
  version = "0-unstable-2019-11-20";

  __structuredAttrs = true;
  strictDeps = true;
  src = fetchFromGitHub {
    owner = "quotunquoteapps";
    repo = "CourierPrime";
    rev = "7f6d46a766acd9391d899090de467c53fd9c9cb0";
    hash = "sha256-pMFZpytNtgoZrBj2Gj8SgJ0Lab8uVY5aQtcO2lFbHj4=";
  };

  nativeBuildInputs = [ installFonts ];

  postInstall = ''
    installFonts ttf $out/share/fonts/truetype
  '';

  meta = {
    description = "Monospaced font designed specifically for screenplays";
    homepage = "https://github.com/quoteunquoteapps/CourierPrime";
    license = lib.licenses.ofl;
    maintainers = [ lib.maintainers.austinbutler ];
    platforms = lib.platforms.all;
  };
})
