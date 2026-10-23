{
  lib,
  gcc15Stdenv,
  cmake,
  fetchFromGitHub,
  fetchpatch,
  hwdata,
  hyprutils,
  hyprwayland-scanner,
  libdisplay-info,
  libdrm,
  libffi,
  libGL,
  libinput,
  libgbm,
  nix-update-script,
  pixman,
  pkg-config,
  seatd,
  udev,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:
gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "aquamarine";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "aquamarine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nGiqEpbQK/tg7Mzyb8kIik9uDcm3cInWDcHRquFAOS4=";
  };

  patches = [
    # Fixes DisplayLink/evdi hotplug, https://github.com/hyprwm/aquamarine/issues/311
    (fetchpatch {
      url = "https://github.com/hyprwm/aquamarine/commit/ff9b933d5559ca88289f8d2521dda39640b5aaab.patch";
      hash = "sha256-laJPtdNoosRpvAkpl8Lv7Zh/cF0eap4lSAZKiAKdKWI=";
    })
  ];

  nativeBuildInputs = [
    cmake
    hyprwayland-scanner
    pkg-config
  ];

  buildInputs = [
    hwdata
    hyprutils
    libdisplay-info
    libdrm
    libffi
    libGL
    libinput
    libgbm
    pixman
    seatd
    udev
    wayland
    wayland-protocols
    wayland-scanner
  ];

  strictDeps = true;

  outputs = [
    "out"
    "dev"
  ];

  cmakeBuildType = "RelWithDebInfo";
  separateDebugInfo = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/hyprwm/aquamarine/releases/tag/v${finalAttrs.version}";
    description = "Very light linux rendering backend library";
    homepage = "https://github.com/hyprwm/aquamarine";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.hyprland ];
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
  };
})
