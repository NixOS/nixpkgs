{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

let
  majorVersion = "0";
  minorVersion = "200";
in
stdenvNoCC.mkDerivation {
  pname = "melete";
  version = "${majorVersion}.${minorVersion}";

  src = fetchzip {
    url = "https://dotcolon.net/files/fonts/melete_${majorVersion}${minorVersion}.zip";
    hash = "sha256-y1xtNM1Oy92gOvbr9J71XNxb1JeTzOgxKms3G2YHK00=";
    stripRoot = false;
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "https://dotcolon.net/font/melete/";
    description = "Headline typeface that could be used as a movie title";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ minijackson ];
    license = lib.licenses.ofl;
  };
}
