{ lib
, stdenv
, fetchurl
, lzip
, ncurses
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "moe";
  version = "1.13";

  src = fetchurl {
    url = "mirror://gnu/moe/moe-${finalAttrs.version}.tar.lz";
    hash = "sha256-Q6VXvFEvidbHGOX0ECnP46BVaCYg642+zmMC80omFGs=";
  };

  prePatch = ''
    substituteInPlace window_vector.cc --replace \
      "insert( 0U, 1," \
      "insert( 0U, 1U,"
  '';

  nativeBuildInputs = [
    lzip
  ];

  buildInputs = [
    ncurses
  ];

  meta = {
    homepage = "https://www.gnu.org/software/moe/";
    description = "A small, 8-bit clean editor";
    longDescription = ''
      GNU moe is a powerful, 8-bit clean, console text editor for ISO-8859 and
      ASCII character encodings. It has a modeless, user-friendly interface,
      online help, multiple windows, unlimited undo/redo capability, unlimited
      line length, unlimited buffers, global search/replace (on all buffers at
      once), block operations, automatic indentation, word wrapping, file name
      completion, directory browser, duplicate removal from prompt histories,
      delimiter matching, text conversion from/to UTF-8, romanization, etc.
    '';
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
# TODO: a configurable, global moerc file
