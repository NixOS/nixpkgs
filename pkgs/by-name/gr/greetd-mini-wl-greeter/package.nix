{
  fetchFromGitHub,
  lib,
  stdenv,
  unstableGitUpdater,
  cairo,
  glib,
  json_c,
  libGL,
  libepoxy,
  libpng,
  libxkbcommon,
  meson,
  ninja,
  pango,
  pkg-config,
  scdoc,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:
stdenv.mkDerivation {
  pname = "greetd-mini-wl-greeter";
  version = "0-unstable-2024-12-27";

  src = fetchFromGitHub {
    owner = "philj56";
    repo = "greetd-mini-wl-greeter";
    rev = "61f25ed34a1a35a061c2f3605fc3d4b37a7d0d8e";
    hash = "sha256-ifeQbzMA9O+yhLveTXpEmgG2BsSp4lxbd3yo8o69fxA=";
  };

  nativeBuildInputs = [
    pkg-config
    libGL
    cairo
    glib
    json_c
    libepoxy
    libpng
    libxkbcommon
    pango
    wayland
    wayland-protocols
    wayland-scanner
  ];

  # https://github.com/philj56/greetd-mini-wl-greeter/issues/2
  mesonBuildType = "release";

  buildInputs = [
    meson
    ninja
    scdoc
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Extremely minimal raw Wayland greeter for greetd";
    license = lib.licenses.mit;
    homepage = "https://github.com/philj56/greetd-mini-wl-greeter";
    mainProgram = "greetd-mini-wl-greeter";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ _0x5a4 ];
  };
}
