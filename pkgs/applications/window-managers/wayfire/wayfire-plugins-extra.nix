{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wayfire
, wayland-scanner
, wf-config
, libevdev
, libinput
, libxkbcommon
, nlohmann_json
, xcbutilwm
, gtkmm3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayfire-plugins-extra";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wayfire-plugins-extra";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TukDomxqfrM45+C7azfO8jVaqk3E5irdphH8U5IYItg=";
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
    libevdev
    libinput
    libxkbcommon
    nlohmann_json
    xcbutilwm
    gtkmm3
  ];

  mesonFlags = [
    # plugins in submodule, packaged individually
    (lib.mesonBool "enable_windecor" false)
    (lib.mesonBool "enable_wayfire_shadows" false)
    (lib.mesonBool "enable_focus_request" false)
  ];

  env = {
    PKG_CONFIG_WAYFIRE_METADATADIR = "${placeholder "out"}/share/wayfire/metadata";
  };

  meta = {
    homepage = "https://github.com/WayfireWM/wayfire-plugins-extra";
    description = "Additional plugins for Wayfire";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rewine ];
    inherit (wayfire.meta) platforms;
  };
})
