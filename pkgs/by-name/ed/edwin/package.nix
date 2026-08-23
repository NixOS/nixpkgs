{
  lib,
  stdenvNoCC,
  fetchurl,
  installFonts,
}:

stdenvNoCC.mkDerivation rec {
  pname = "edwin";
  version = "0.54";

  src = fetchurl {
    url = "https://github.com/MuseScoreFonts/Edwin/archive/refs/tags/v${version}.tar.gz";
    hash = "sha256-F6BzwnrsaELegdo6Bdju1OG+RI9zKnn4tIASR3q6zYk=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Text font for musical scores";
    homepage = "https://github.com/MuseScoreFonts/Edwin";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ moni ];
  };
}
