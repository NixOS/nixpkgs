{ stdenv, lib, fetchFromGitHub, cairo, libxkbcommon
, pango, fribidi, harfbuzz, pcre, pkg-config, scdoc
, ncursesSupport ? true, ncurses
, waylandSupport ? true, wayland, wayland-protocols, wayland-scanner
, x11Support ? true, xorg
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bemenu";
  version = "0.6.21";

  src = fetchFromGitHub {
    owner = "Cloudef";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    hash = "sha256-E/5wN7HpdBt//jFe9yAB8fuHKiFJ7D1UAJEvG8KBJ6k=";
  };

  strictDeps = true;
  nativeBuildInputs = [ pkg-config scdoc ]
    ++ lib.optionals waylandSupport [ wayland-scanner ];

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

  makeFlags = ["PREFIX=$(out)"];

  buildFlags = ["clients"]
    ++ lib.optional ncursesSupport "curses"
    ++ lib.optional waylandSupport "wayland"
    ++ lib.optional x11Support "x11";

  meta = with lib; {
    homepage = "https://github.com/Cloudef/bemenu";
    description = "Dynamic menu library and client program inspired by dmenu";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ lheckemann ];
    mainProgram = "bemenu";
    platforms = with platforms; linux;
  };
})
