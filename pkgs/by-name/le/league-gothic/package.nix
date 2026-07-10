{
  lib,
  fetchzip,
  stdenvNoCC,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "league-gothic";
  version = "1.601";

  src = fetchzip {
    url = "https://github.com/theleagueof/league-gothic/releases/download/${finalAttrs.version}/LeagueGothic-${finalAttrs.version}.tar.xz";
    hash = "sha256-emkXKyQw4R0Zgg02oJsvBkqV0jmczP0tF0K2IKqJHMA=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Revival of an old classic, Alternate Gothic #1";
    longDescription = ''
      League Gothic is a revival of an old classic, and one of our favorite
      typefaces, Alternate Gothic #1. It was originally designed by Morris
      Fuller Benton for the American Type Founders Company in 1903. The company
      went bankrupt in 1993, and since the original typeface was created before
      1923, the typeface is in the public domain.

      We decided to make our own version, and contribute it to the Open Source
      Type Movement. Thanks to a commission from the fine & patient folks over
      at WND.com, it’s been revised & updated with contributions from Micah
      Rich, Tyler Finck, and Dannci, who contributed extra glyphs.
    '';
    homepage = "https://www.theleagueofmoveabletype.com/league-gothic";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ minijackson ];
  };
})
