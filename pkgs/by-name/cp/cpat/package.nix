{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cpat";
  version = "1.4.2";

  src = fetchurl {
    url = "https://downloads.sourceforge.net/project/cpat/v1.4.2/cpat-${finalAttrs.version}.tar.gz";
    hash = "sha256-viVbaU21tI4lU+0WoSzRW81aUPzCIkJKjJR/BPEFO2c=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  patches = [ ./format-security.patch ];

  buildInputs = [ ncurses ];

  meta = {
    description = "A curses based card games application";
    homepage = "https://sourceforge.net/projects/cpat/";
    mainProgram = "cpat";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
