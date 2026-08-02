{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation rec {
  pname = "source-sans";
  version = "3.052";

  outputs = [
    "out"
    "webfont"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchzip {
    url = "https://github.com/adobe-fonts/source-sans/archive/${version}R.zip";
    hash = "sha256-yzbYy/ZS1GGlgJW+ARVWF4tjFqmMq7x+YqSQnojtQBs=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "https://adobe-fonts.github.io/source-sans/";
    description = "Sans serif font family for user interface environments";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
