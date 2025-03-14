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
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "aquamarine";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ldWD4ci3LcBIfUN41qlBO/oR5chcsRLejMbSW8eH628=";
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
    description = "A very light linux rendering backend library";
    homepage = "https://github.com/hyprwm/aquamarine";
    license = lib.licenses.bsd3;
    maintainers = lib.teams.hyprland.members;
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
  };
})
