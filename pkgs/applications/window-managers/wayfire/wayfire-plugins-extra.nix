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
  # Pixdecor is broken here. Use pixdecor.
  withPixdecorPlugin ? false,
  withWayfireShadowsPlugin ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayfire-plugins-extra";
  version = "0.11.0-unstable-2026-07-17";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wayfire-plugins-extra";
    rev = "4290ddf13bfadb344d45cb25c47f7825bbdc8a30";
    hash = "sha256-HhCGB4ZslglB4o+xZ1gUmeUKWTR1VPnYS2Maqi++OaY=";
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

    problems = lib.optionalAttrs withPixdecorPlugin {
      broken.message = "Pixdecor is broken in wayfire-plugins-extra. Use `wayfirePlugins.pixdecor` instead if you want it.";
    };
  };
})
