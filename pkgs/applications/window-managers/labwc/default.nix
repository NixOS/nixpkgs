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
<<<<<<< HEAD
, wlroots
=======
, wlroots_0_16
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, xcbutilwm
, xwayland
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "labwc";
  version = "0.6.4";
=======
let
  wlroots = wlroots_0_16;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "labwc";
  version = "0.6.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "labwc";
    repo = "labwc";
    rev = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-8FMC0tq5Gp5qDPUmoJTCrHEergDMUbiTco17jPTJUgE=";
=======
    hash = "sha256-yZ1tXx7AA9pFc5C6c/J3B03/TfXw1PsAunNNiee3BGU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
