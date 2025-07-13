{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:
stdenv.mkDerivation rec {
  pname = "moon-buggy";
  version = "1.0.51";

  buildInputs = [
    ncurses
  ];

  src = fetchurl {
    url = "https://m.seehuhn.de/programs/moon-buggy-${version}.tar.gz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  meta = {
    description = "Simple character graphics game where you drive some kind of car across the moon's surface";
    mainProgram = "moon-buggy";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.rybern ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    homepage = "https://www.seehuhn.de/pages/moon-buggy";
  };
}
