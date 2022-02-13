{ stdenv, lib, fetchFromGitHub, fetchpatch, cairo, libxkbcommon
, pango, fribidi, harfbuzz, pcre, pkg-config
, ncursesSupport ? true, ncurses ? null
, waylandSupport ? true, wayland ? null, wayland-protocols ? null
, x11Support ? true, xorg ? null
}:

assert ncursesSupport -> ncurses != null;
assert waylandSupport -> ! lib.elem null [wayland wayland-protocols];
assert x11Support -> xorg != null;

stdenv.mkDerivation rec {
  pname = "bemenu";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "Cloudef";
    repo = pname;
    rev = version;
    sha256 = "5xRM3NQfomG0vJheNEBLy3OaS6UEwabNKYa96u2md6M=";
  };

  nativeBuildInputs = [ pkg-config pcre ];

  makeFlags = ["PREFIX=$(out)"];

  buildFlags = ["clients"]
    ++ lib.optional ncursesSupport "curses"
    ++ lib.optional waylandSupport "wayland"
    ++ lib.optional x11Support "x11";

  buildInputs = with lib; [
    cairo
    fribidi
    harfbuzz
    libxkbcommon
    pango
  ] ++ optional ncursesSupport ncurses
    ++ optionals waylandSupport [ wayland wayland-protocols ]
    ++ optionals x11Support [
      xorg.libX11 xorg.libXinerama xorg.libXft
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
