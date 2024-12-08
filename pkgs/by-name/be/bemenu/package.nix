{ stdenv, lib, fetchFromGitHub, cairo, libxkbcommon
, pango, fribidi, harfbuzz, pkg-config, scdoc
, ncursesSupport ? true, ncurses
, waylandSupport ? true, wayland, wayland-protocols, wayland-scanner
, x11Support ? true, xorg
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bemenu";
  version = "0.6.23";

  src = fetchFromGitHub {
    owner = "Cloudef";
    repo = "bemenu";
    rev = finalAttrs.version;
    hash = "sha256-0vpqJ2jydTt6aVni0ma0g+80PFz+C4xJ5M77sMODkSg=";
  };

  strictDeps = true;
  nativeBuildInputs = [ pkg-config scdoc ]
    ++ lib.optionals waylandSupport [ wayland-scanner ];

  buildInputs = [
    cairo
    fribidi
    harfbuzz
    libxkbcommon
    pango
  ] ++ lib.optional ncursesSupport ncurses
    ++ lib.optionals waylandSupport [ wayland wayland-protocols ]
    ++ lib.optionals x11Support [
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
    maintainers = with maintainers; [ crertel ];
    mainProgram = "bemenu";
    platforms = with platforms; linux;
  };
})
