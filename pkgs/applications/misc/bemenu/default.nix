{ stdenv, lib, fetchFromGitHub, fetchpatch, cairo, libxkbcommon
, pango, fribidi, harfbuzz, pcre, pkg-config, scdoc
, ncursesSupport ? true, ncurses
, waylandSupport ? true, wayland, wayland-protocols, wayland-scanner
, x11Support ? true, xorg
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "bemenu";
  version = "0.6.16";

  src = fetchFromGitHub {
    owner = "Cloudef";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    sha256 = "sha256-K9a9BUodpKwvEOhnF2/TGo5zLm7F9RzqSCcWzuhKcWA=";
=======
stdenv.mkDerivation rec {
  pname = "bemenu";
  version = "0.6.14";

  src = fetchFromGitHub {
    owner = "Cloudef";
    repo = pname;
    rev = version;
    sha256 = "sha256-bMnnuT+LNNKphmvVcD1aaNZxasSGOEcAveC4stCieG8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    mainProgram = "bemenu";
    platforms = with platforms; linux;
  };
})
=======
    platforms = with platforms; linux;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
