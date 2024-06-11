{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wayfire
, wf-config
, libevdev
, libinput
, libxkbcommon
, nlohmann_json
, xcbutilwm
, gtkmm3
, gtk-layer-shell
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayfire-plugins-extra";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wayfire-plugins-extra";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MF4tDzIZnnTXH2ZUxltIw1RP3pfRQFGrc/n9H47yW0g";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
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
    gtk-layer-shell
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
