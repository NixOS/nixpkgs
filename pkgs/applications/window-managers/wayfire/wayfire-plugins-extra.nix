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
  version = "0.11.0-unstable-2025-12-18";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wayfire-plugins-extra";
    rev = "439a9b4dc66f1174f97e0db18b15726751fbf6d1";
    hash = "sha256-lBLdlWcT2byEiPKoadKvWVHYNrhGGkliF3CSPwV0S5s=";
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
