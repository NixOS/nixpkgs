{
  lib,
  stdenv,
  fetchFromCodeberg,
  bison,
  cairo,
  flex,
  libbsd,
  libevent,
  libxkbcommon,
  meson,
  ncurses,
  ninja,
  pango,
  pixman,
  pkg-config,
  lowdown,
  wayland,
  wayland-protocols,
  wayland-scanner,
  xwayland,

}:
stdenv.mkDerivation (finalAttrs: {
  name = "cow";
  version = "0.3";

  src = fetchFromCodeberg {
    owner = "cow-wm";
    repo = "cow";
    tag = finalAttrs.version;
    hash = "sha256-TbnsCsBHJDsMkuOLPlesYzrY3pHd9qh/ZXQsszSJgxE=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  buildInputs = [
    cairo
    libbsd
    libevent
    libxkbcommon
    ncurses
    pango
    pixman
    wayland
    wayland-protocols
    wayland-scanner
    xwayland
  ];

  nativeBuildInputs = [
    bison
    flex
    lowdown
    meson
    ninja
    pkg-config
  ];

  meta = {
    description = "A stacking window manager using river as the compositor";
    homepage = "https://cow-wm.codeberg.page/cow/";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      dvn0
    ];
  };
})
