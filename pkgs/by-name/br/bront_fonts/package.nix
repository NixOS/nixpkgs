{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "bront_fonts";
  version = "0-unstable-2015-06-28";

  src = fetchFromGitHub {
    owner = "chrismwendt";
    repo = "bront";
    rev = "aef23d9a11416655a8351230edb3c2377061c077";
    hash = "sha256-ZD0I5buRGV1GRSwofI/aVc+vucWjazQWY769m8J+ous=";
  };

  preInstall = "rm {DejaVuSansMono,UbuntuMono}.ttf";

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Bront Fonts";
    longDescription = "Ubuntu Mono Bront and DejaVu Sans Mono Bront fonts.";
    homepage = "https://github.com/chrismwendt/bront";
    license = with lib.licenses; [
      bitstreamVera
      ufl
    ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pancaek ];
  };
}
