{ lib
, stdenv
, fetchFromGitHub
, cairo
, gettext
, glib
, libdrm
, libinput
, libpng
, librsvg
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
, wayland-scanner
, wlroots
, xcbutilwm
, xwayland
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "labwc";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = "labwc";
    rev = finalAttrs.version;
    hash = "sha256-ahupqI4mLrgQQjzdfLeQATc2iXQ0V6Sz5f6Yv1koLL0=";
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
    libpng
    librsvg
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

  outputs = [ "out" "man" ];

  strictDeps = true;

  mesonFlags = [
    (lib.mesonEnable "xwayland" true)
  ];

  meta = {
    homepage = "https://github.com/labwc/labwc";
    description = "A Wayland stacking compositor, inspired by Openbox";
    changelog = "https://raw.githubusercontent.com/labwc/labwc/${finalAttrs.version}/NEWS.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    inherit (wayland.meta) platforms;
  };
})
