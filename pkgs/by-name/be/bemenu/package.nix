{
  stdenv,
  lib,
  fetchFromGitHub,
  cairo,
  libxkbcommon,
  pango,
  fribidi,
  harfbuzz,
  pkg-config,
  scdoc,
  makeWrapper,
  ncursesSupport ? true,
  ncurses,
  waylandSupport ? stdenv.hostPlatform.isLinux,
  wayland,
  wayland-protocols,
  wayland-scanner,
  x11Support ? stdenv.hostPlatform.isLinux,
  xorg,
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

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace GNUmakefile --replace '-soname' '-install_name'
  '';

  strictDeps = true;
  nativeBuildInputs = [
    pkg-config
    scdoc
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin makeWrapper
  ++ lib.optional waylandSupport wayland-scanner;

  buildInputs = [
    cairo
    fribidi
    harfbuzz
    libxkbcommon
    pango
  ]
  ++ lib.optional ncursesSupport ncurses
  ++ lib.optionals waylandSupport [
    wayland
    wayland-protocols
  ]
  ++ lib.optionals x11Support [
    xorg.libX11
    xorg.libXinerama
    xorg.libXft
    xorg.libXdmcp
    xorg.libpthreadstubs
    xorg.libxcb
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  buildFlags = [
    "clients"
  ]
  ++ lib.optional ncursesSupport "curses"
  ++ lib.optional waylandSupport "wayland"
  ++ lib.optional x11Support "x11";

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    so="$(find "$out/lib" -name "libbemenu.so.[0-9]" -print -quit)"
    for f in "$out/bin/"*; do
        install_name_tool -change "$(basename $so)" "$so" $f
        wrapProgram $f --set BEMENU_BACKEND curses
    done
  '';

  meta = with lib; {
    homepage = "https://github.com/Cloudef/bemenu";
    description = "Dynamic menu library and client program inspired by dmenu";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ crertel ];
    mainProgram = "bemenu";
    platforms = with platforms; linux ++ darwin;
  };
})
