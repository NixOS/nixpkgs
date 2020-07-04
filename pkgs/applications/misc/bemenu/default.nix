{ stdenv, lib, fetchFromGitHub, cairo, libxkbcommon
, pango, fribidi, harfbuzz, pcre, pkgconfig
, ncursesSupport ? true, ncurses ? null
, waylandSupport ? true, wayland ? null, wayland-protocols ? null
, x11Support ? true, xlibs ? null, xorg ? null
}:

assert ncursesSupport -> ncurses != null;
assert waylandSupport -> ! lib.elem null [wayland wayland-protocols];
assert x11Support -> xlibs != null && xorg != null;

stdenv.mkDerivation rec {
  pname = "bemenu";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "Cloudef";
    repo = pname;
    rev = version;
    sha256 = "1fjcs9d3533ay3nz79cx3c0lmy2chgragr2lhsy0xl2ckr0iins0";
  };

  nativeBuildInputs = [ pkgconfig pcre ];

  makeFlags = ["PREFIX=$(out)"];

  buildFlags = ["clients"]
    ++ lib.optional ncursesSupport "curses"
    ++ lib.optional waylandSupport "wayland"
    ++ lib.optional x11Support "x11";

  buildInputs = with stdenv.lib; [
    cairo
    fribidi
    harfbuzz
    libxkbcommon
    pango
  ] ++ optional ncursesSupport ncurses
    ++ optionals waylandSupport [ wayland wayland-protocols ]
    ++ optionals x11Support [
      xlibs.libX11 xlibs.libXinerama xlibs.libXft
      xorg.libXdmcp xorg.libpthreadstubs xorg.libxcb
    ];

  meta = with lib; {
    homepage = "https://github.com/Cloudef/bemenu";
    description = "Dynamic menu library and client program inspired by dmenu";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ lheckemann ];
    platforms = with platforms; linux;
  };
}
