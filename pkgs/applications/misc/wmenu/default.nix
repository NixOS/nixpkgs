{
  lib,
  stdenv,
  fetchFromSourcehut,
  pkg-config,
  meson,
  ninja,
  cairo,
  pango,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libxkbcommon,
  scdoc,
}:

stdenv.mkDerivation rec {
  pname = "wmenu";
  version = "0.1.8";

  strictDeps = true;

  src = fetchFromSourcehut {
    owner = "~adnano";
    repo = "wmenu";
    rev = version;
    hash = "sha256-gVoqRHQ5bcY58LTgKxpPM1PnZJrLRoSOJUiYYqc/vRI=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    wayland-scanner
  ];
  buildInputs = [
    cairo
    pango
    wayland
    libxkbcommon
    wayland-protocols
    scdoc
  ];

  meta = with lib; {
    description = "An efficient dynamic menu for Sway and wlroots based Wayland compositors";
    homepage = "https://git.sr.ht/~adnano/wmenu";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ eken ];
    mainProgram = "wmenu";
  };
}
