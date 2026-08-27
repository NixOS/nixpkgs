{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  scdoc,
  wayland-scanner,
  pixman,
  libpng,
  libjpeg,
  wayland,
  wayland-protocols,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "frzscr";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "heather7283";
    repo = "frzscr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DwgmAdDi5Ez6SLwBeVUIilbgPZGv7LaODERHaFirjFo=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
  ];

  buildInputs = [
    pixman
    libpng
    libjpeg
    wayland
    wayland-protocols
  ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/heather7283/frzscr";
    description = "Freeze screen (wayland)";
    license = lib.licenses.gpl3Only;
    mainProgram = "frzscr";
    maintainers = with lib.maintainers; [ deni111bg ];
    platforms = lib.platforms.linux;
  };
})
