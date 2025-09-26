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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wcm";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wcm";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-oaaEtyu/9XVhFTkmD7WjScMycpKf+M7oPyQatbY23Vo=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
    wrapGAppsHook3
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
  ];

  mesonFlags = [
    "-Denable_wdisplays=false"
  ];

  meta = {
    homepage = "https://github.com/WayfireWM/wcm";
    description = "Wayfire Config Manager";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      wucke13
      wineee
    ];
    platforms = lib.platforms.unix;
    mainProgram = "wcm";
  };
})
