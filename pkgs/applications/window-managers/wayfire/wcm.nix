{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  wayfire,
  wf-shell,
  wayland-scanner,
  wayland-protocols,
  gtk3,
  gtkmm3,
  libevdev,
  libxml2,
  libxkbcommon,
  fmt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wcm";
  version = "0.11.0-unstable-2026-07-28";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wcm";
    rev = "14f2e03fc4bfa3a20d10b913461636363e39240c";
    fetchSubmodules = true;
    hash = "sha256-ShclD93AQDHXwjCDTN8zom1xr3v4oMKLzO2q7B3ZAPg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
    wrapGAppsHook3
    fmt.dev
  ];

  buildInputs = [
    wayfire
    wf-shell
    wayland-protocols
    gtk3
    gtkmm3
    libevdev
    libxml2
    libxkbcommon
    fmt
  ];

  meta = {
    homepage = "https://github.com/WayfireWM/wcm";
    description = "Wayfire Config Manager";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      teatwig
      wucke13
      wineee
    ];
    platforms = lib.platforms.unix;
    mainProgram = "wcm";
  };
})
