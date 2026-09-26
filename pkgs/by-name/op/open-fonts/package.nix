{
  lib,
  stdenvNoCC,
  fetchurl,
  installFonts,
}:

stdenvNoCC.mkDerivation rec {
  pname = "open-fonts";
  version = "0.7.0";

  src = fetchurl {
    url = "https://github.com/kiwi0fruit/open-fonts/releases/download/${version}/open-fonts.tar.xz";
    hash = "sha256-NJKbdrvgZz9G7mjAJYzN7rU/fo2xRFZA2BbQ+A56iPw=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Collection of beautiful free and open source fonts";
    homepage = "https://github.com/kiwi0fruit/open-fonts";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ moni ];
  };
}
