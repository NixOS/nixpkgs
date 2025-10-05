{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
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
stdenv.mkDerivation (finalAttrs: {
  pname = "aquamarine";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "aquamarine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-POePremlUY5GyA1zfbtic6XLxDaQcqHN6l+bIxdT5gc=";
  };

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
