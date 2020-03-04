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
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Cloudef";
    repo = pname;
    rev = version;
    sha256 = "03k8wijdgj5nwmvgjhsrlh918n719789fhs4dqm23pd00rapxipk";
  };

  nativeBuildInputs = [ cmake pkgconfig pcre ];

  cmakeFlags =  [
    "-DBEMENU_CURSES_RENDERER=${if ncursesSupport then "ON" else "OFF"}"
    "-DBEMENU_WAYLAND_RENDERER=${if waylandSupport then "ON" else "OFF"}"
    "-DBEMENU_X11_RENDERER=${if x11Support then "ON" else "OFF"}"
  ];

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
