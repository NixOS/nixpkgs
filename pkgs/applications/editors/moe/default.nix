{ lib, stdenv
, fetchurl
, ncurses
, lzip
}:

stdenv.mkDerivation rec {
  pname = "moe";
  version = "1.12";

  src = fetchurl {
    url = "mirror://gnu/moe/${pname}-${version}.tar.lz";
    sha256 = "sha256-iohfK+Qm+OBK05yWASvYYJVAhaI3RPJFFmMWiCbXoeg=";
  };

  prePatch = ''
    substituteInPlace window_vector.cc --replace \
      "insert( 0U, 1," \
      "insert( 0U, 1U,"
  '';

  nativeBuildInputs = [ lzip ];
  buildInputs = [ ncurses ];

  meta = with lib; {
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
    homepage = "https://www.gnu.org/software/moe/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
# TODO: a configurable, global moerc file
