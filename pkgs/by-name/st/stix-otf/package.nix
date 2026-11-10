{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation rec {
  pname = "stix-otf";
  version = "1.1.1";

  src = fetchzip {
    url = "https://sources.debian.org/src/fonts-stix/1.1.1-4.1/STIXv${version}-word.zip";
    stripRoot = false;
    hash = "sha256-M3STue+RPHi8JgZZupV0dVLZYKBiFutbBOlanuKkD08=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "http://www.stixfonts.org/";
    description = "Fonts for Scientific and Technical Information eXchange";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.rycee ];
  };
}
