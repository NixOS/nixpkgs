{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wayfire,
  wayland-scanner,
  wf-config,
  boost,
  libdrm,
  libevdev,
  libinput,
  libxkbcommon,
  vulkan-headers,
  libxcb-wm,
  gtkmm3,
  withFiltersPlugin ? true,
  withFocusRequestPlugin ? true,
  withPixdecorPlugin ? true,
  withWayfireShadowsPlugin ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayfire-plugins-extra";
  version = "0.11.0-unstable-2026-04-23";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wayfire-plugins-extra";
    rev = "a65af2577986fbbdf8100048ad9943aff8ab27ff";
    hash = "sha256-U6QllOwGbJQJECe1ofoiV659cLOJyIvYwqshYCCXlFg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayfire
    wf-config
    boost
    libdrm
    libevdev
    libinput
    libxkbcommon
    vulkan-headers
    libxcb-wm
    gtkmm3
  ];

  mesonFlags = [
    (lib.mesonBool "enable_filters" withFiltersPlugin)
    (lib.mesonBool "enable_focus_request" withFocusRequestPlugin)
    (lib.mesonBool "enable_pixdecor" withPixdecorPlugin)
    (lib.mesonBool "enable_wayfire_shadows" withWayfireShadowsPlugin)
  ];

  env = {
    PKG_CONFIG_WAYFIRE_METADATADIR = "${placeholder "out"}/share/wayfire/metadata";
  };

  meta = {
    homepage = "https://github.com/WayfireWM/wayfire-plugins-extra";
    description = "Additional plugins for Wayfire";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wineee ];
    inherit (wayfire.meta) platforms;
  };
})
