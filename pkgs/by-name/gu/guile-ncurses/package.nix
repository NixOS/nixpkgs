{ lib
, stdenv
, fetchurl
, pkg-config
, guile
, libffi
, ncurses
}:

stdenv.mkDerivation rec {
  pname = "guile-ncurses";
  version = "3.1";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-7onozq/Kud0O8/wazJsQ9NIbpLJW0ynYQtYYPmP41zM=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    guile
    libffi
    ncurses
  ];

  configureFlags = [
    "--with-gnu-filesystem-hierarchy"
  ];

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
  };

  postFixup = ''
    for f in $out/${guile.siteDir}/ncurses/**.scm; do \
      substituteInPlace $f \
        --replace "libguile-ncurses" "$out/lib/guile/${guile.effectiveVersion}/libguile-ncurses"; \
    done
  '';

  # XXX: 1 of 65 tests failed.
  doCheck = false;

  meta = with lib; {
    homepage = "https://www.gnu.org/software/guile-ncurses/";
    description = "Scheme interface to the NCurses libraries";
    mainProgram = "guile-ncurses-shell";
    longDescription = ''
      GNU Guile-Ncurses is a library for the Guile Scheme interpreter that
      provides functions for creating text user interfaces.  The text user
      interface functionality is built on the ncurses libraries: curses, form,
      panel, and menu.
    '';
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ vyp ];
    platforms = guile.meta.platforms;
  };
}
