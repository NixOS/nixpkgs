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
stdenv.mkDerivation (finalAttrs: {
  pname = "labwc";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = "labwc";
    rev = finalAttrs.version;
    hash = "sha256-P1hKYTW++dpV3kdmI5nBGun080gVTrKzi2WOJKR84j4=";
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
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    inherit (wayland.meta) platforms;
  };
})
