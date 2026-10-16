{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "sangyo_ttf";
  version = "20250205";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchzip {
    url = "https://web.archive.org/web/20260302161632/https://dl.dafont.com/dl/?f=sangyo";
    hash = "sha256-watoLEE0jtIdaOBJEmzpxbCsxFaq8j8hJ99XflhEsRg=";
    extension = "zip";
    stripRoot = false;
  };

  nativeBuildInputs = [ installFonts ];

  meta = with lib; {
    description = "Blocky Cyrillic font";
    homepage = "https://ggbot.itch.io/sangyo-font";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ gigahawk ];
  };
}
