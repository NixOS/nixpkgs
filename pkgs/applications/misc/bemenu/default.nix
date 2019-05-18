{ stdenv, fetchFromGitHub, cairo, cmake, libxkbcommon
, pango, fribidi, harfbuzz, pcre, pkgconfig
, ncursesSupport ? true, ncurses ? null
, waylandSupport ? true, wayland ? null
, x11Support ? true, xlibs ? null, xorg ? null
}:

assert ncursesSupport -> ncurses != null;
assert waylandSupport -> wayland != null;
assert x11Support -> xlibs != null && xorg != null;

stdenv.mkDerivation rec {
  pname = "bemenu";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Cloudef";
    repo = "bemenu";
    rev = "33e540a2b04ce78f5c7ab4a60b899c67f586cc32";
    sha256 = "11h55m9dx6ai12pqij52ydjm36dvrcc856pa834njihrp626pl4w";
  };

  nativeBuildInputs = [ cmake pkgconfig pcre ];

  buildInputs = with stdenv.lib; [
    cairo
    fribidi
    harfbuzz
    libxkbcommon
    pango
  ] ++ optionals ncursesSupport [ ncurses ]
    ++ optionals waylandSupport [ wayland ]
    ++ optionals x11Support [
      xlibs.libX11 xlibs.libXinerama xlibs.libXft
      xorg.libXdmcp xorg.libpthreadstubs xorg.libxcb
    ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/Cloudef/bemenu";
    description = "Dynamic menu library and client program inspired by dmenu";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ thiagokokada ];
    platforms = with platforms; linux;
  };
}
