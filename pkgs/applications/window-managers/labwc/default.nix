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
, meson
, ninja
, pango
, pkg-config
, scdoc
, wayland
, wayland-protocols
, wlroots_0_16
, xcbutilwm
, xwayland
}:

let
  wlroots = wlroots_0_16;
in
stdenv.mkDerivation (self: {
  pname = "labwc";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = "labwc";
    rev = self.version;
    hash = "sha256-PfvtNbSAz1vt0+ko4zRPyRRN+lhQoA2kJ2xoJy5o4So=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
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
    changelog = "https://raw.githubusercontent.com/labwc/labwc/${self.version}/NEWS.md";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    inherit (wayland.meta) platforms;
  };
})
