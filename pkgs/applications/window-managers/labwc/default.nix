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
, wlroots
, xcbutilwm
, xwayland
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "labwc";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = "labwc";
    rev = finalAttrs.version;
    hash = "sha256-8FMC0tq5Gp5qDPUmoJTCrHEergDMUbiTco17jPTJUgE=";
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
