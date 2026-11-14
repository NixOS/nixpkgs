{
  lib,
  gcc16Stdenv,
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
gcc16Stdenv.mkDerivation (finalAttrs: {
  pname = "aquamarine";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "aquamarine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/ccpiTctvwVY8msdVa3Ssj/iKV2LiY2+s72o0bUKFw4=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    cmake
    hyprwayland-scanner
    pkg-config
  ];

  propagatedBuildInputs = [
    hyprutils
    libdrm
    wayland
  ];

  buildInputs = [
    hwdata
    libdisplay-info
    libffi
    libGL
    libinput
    libgbm
    pixman
    seatd
    udev
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
