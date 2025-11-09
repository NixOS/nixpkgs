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
  xcbutilwm,
  gtkmm3,
  withFiltersPlugin ? true,
  withFocusRequestPlugin ? true,
  withPixdecorPlugin ? true,
  withWayfireShadowsPlugin ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayfire-plugins-extra";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wayfire-plugins-extra";
    rev = "v${finalAttrs.version}";
    hash = "sha256-C5dgs81R4XuPjIm7sj1Mtu4IMIRBEYU6izg2olymeVI=";
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
    xcbutilwm
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
