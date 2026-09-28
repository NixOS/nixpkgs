{
  lib,
  stdenvNoCC,
  fetchurl,
  installFonts,
}:

stdenvNoCC.mkDerivation rec {
  pname = "scientifica";
  version = "2.3";

  src = fetchurl {
    url = "https://github.com/oppiliappan/scientifica/releases/download/v${version}/scientifica.tar";
    hash = "sha256-8IV4aaDoRsbxddy4U90fEZ6henUhjmO38HNtWo4ein8=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Tall and condensed bitmap font for geeks";
    homepage = "https://github.com/oppiliappan/scientifica";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ moni ];
  };
}
