{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "moon-buggy";
  version = "1.1.0";

  buildInputs = [
    ncurses
  ];

  src = fetchurl {
    url = "http://www.seehuhn.de/programs/moon-buggy/moon-buggy-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-JZrm57GDjEBTKvXA8gzXxhc81cVS7eQIEUBkR1vPxbY=";
  };

  meta = {
    description = "Simple character graphics game where you drive some kind of car across the moon's surface";
    mainProgram = "moon-buggy";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.rybern ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    homepage = "https://www.seehuhn.de/pages/moon-buggy";
  };
})
