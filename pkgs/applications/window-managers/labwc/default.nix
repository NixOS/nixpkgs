{ lib
, stdenv
, fetchFromGitHub
, cairo
, glib
, libdrm
, libinput
, libxcb
, libxkbcommon
, libxml2
, gettext
, meson
, ninja
, pango
, pkg-config
, scdoc
, wayland-scanner
, wayland
, wayland-protocols
, wlroots_0_16
, xcbutilwm
, xwayland
}:

let
  wlroots = wlroots_0_16;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "labwc";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = "labwc";
    rev = finalAttrs.version;
    hash = "sha256-yZ1tXx7AA9pFc5C6c/J3B03/TfXw1PsAunNNiee3BGU=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
  ];

  buildInputs = [
    cairo
    glib
    libdrm
    libinput
    libxcb
    libxkbcommon
    libxml2
    pango
    wayland
    wayland-protocols
    wlroots
    xcbutilwm
    xwayland
  ];

  mesonFlags = [
    (lib.mesonEnable "xwayland" true)
  ];

  meta = with lib; {
    homepage = "https://github.com/labwc/labwc";
    description = "A Wayland stacking compositor, similar to Openbox";
    changelog = "https://raw.githubusercontent.com/labwc/labwc/${finalAttrs.version}/NEWS.md";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    inherit (wayland.meta) platforms;
  };
})
