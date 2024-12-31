{
  lib,
  gcc14Stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libGL,
  libxkbcommon,
  hyprlang,
  hyprutils,
  pam,
  sdbus-cpp_2,
  systemdLibs,
  wayland,
  wayland-protocols,
  wayland-scanner,
  cairo,
  file,
  libjpeg,
  libwebp,
  pango,
  libdrm,
  mesa,
  nix-update-script,
}:

gcc14Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprlock";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprlock";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sUIsjWpZLplSJXWyJcDZdvDweksXLH5r9GSkwg0kgBw=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    cairo
    file
    hyprlang
    hyprutils
    libdrm
    libGL
    libjpeg
    libwebp
    libxkbcommon
    mesa
    pam
    pango
    sdbus-cpp_2
    systemdLibs
    wayland
    wayland-protocols
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hyprland's GPU-accelerated screen locking utility";
    homepage = "https://github.com/hyprwm/hyprlock";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      iynaix
      johnrtitor
    ];
    mainProgram = "hyprlock";
    platforms = lib.platforms.linux;
  };
})
