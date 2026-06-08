{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation rec {
  pname = "stix-two";
  version = "2.13";

  outputs = [
    "out"
    "webfont"
  ];

  preInstall = "rm -r static_ttf_woff2/";

  src = fetchzip {
    url = "https://github.com/stipub/stixfonts/raw/v${version}/zipfiles/STIX${
      builtins.replaceStrings [ "." ] [ "_" ] version
    }-all.zip";
    stripRoot = false;
    hash = "sha256-hfQmrw7HjlhQSA0rVTs84i3j3iMVR0k7tCRBcB6hEpU=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "https://www.stixfonts.org/";
    description = "Fonts for Scientific and Technical Information eXchange";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.rycee ];
  };
}
