{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wayland
, wrapGAppsHook
, wayfire
, wf-shell
, wf-config
, wayland-scanner
, wayland-protocols
, gtk3
, libevdev
, libxml2
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wcm";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wcm";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-LJR9JGl49o4O6LARofz3jOeAqseGcmzVhMnhk/aobUU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
    wrapGAppsHook
  ];

  buildInputs = [
    wayfire
    wf-config
    wf-shell
    wayland
    wayland-protocols
    gtk3
    libevdev
    libxml2
  ];

  mesonFlags = [
    "-Denable_wdisplays=false"
  ];

  meta = {
    homepage = "https://github.com/WayfireWM/wcm";
    description = "Wayfire Config Manager";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qyliss wucke13 rewine ];
    platforms = lib.platforms.unix;
    mainProgram = "wcm";
  };
})
