{ stdenv
, lib
, fetchFromGitLab
, meson
, ninja
, pkg-config
, wayfire
, wf-config
, wayland
, pango
, libinput
, libxkbcommon
, librsvg
, libGL
, xcbutilwm
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "focus-request";
  version = "0.8.0.2";

  src = fetchFromGitLab {
    owner = "wayfireplugins";
    repo = "focus-request";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kUYvLC28IPrvnMT/wKFRlOVkc2ohF3k0T/Qrm/zVkpE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    wayfire
    wf-config
    wayland
    pango
    libinput
    libxkbcommon
    librsvg
    libGL
    xcbutilwm
  ];

  env = {
    PKG_CONFIG_WAYFIRE_METADATADIR = "${placeholder "out"}/share/wayfire/metadata";
  };

  meta = {
    homepage = "https://gitlab.com/wayfireplugins/focus-request";
    description = "Wayfire plugin provides a mechanism to grant focus to views that make a focus self-request";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rewine ];
    inherit (wayfire.meta) platforms;
  };
})
