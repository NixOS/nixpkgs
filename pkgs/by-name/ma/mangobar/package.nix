{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,
  cjson,
  fcft,
  tllist,
  pixman,
  cairo,
  pango,
  libpulseaudio,
  systemd,
  gdk-pixbuf,
  alsa-lib,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mangobar";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "mangowm";
    repo = "mangobar";
    tag = finalAttrs.version;
    hash = "sha256-73MvfJpAF4q66ekZg73UFTzgkduG9k5yUgzaCTIaip4=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wayland-protocols
    cjson
    fcft
    tllist
    pixman
    cairo
    pango
    libpulseaudio
    systemd
    gdk-pixbuf
    alsa-lib
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wayland status bar for mangowm, built on wlr-layer-shell";
    homepage = "https://github.com/mangowm/mangobar";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ yvnth ];
    mainProgram = "mangobar";
  };
})
