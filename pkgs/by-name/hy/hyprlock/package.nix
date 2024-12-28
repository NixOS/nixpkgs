{
  lib,
  gcc14Stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libGL,
  libxkbcommon,
  hyprgraphics,
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
  libgbm,
  nix-update-script,
}:

gcc14Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprlock";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprlock";
    rev = "v${finalAttrs.version}";
    hash = "sha256-41/fFxlGCf1q+WJwdzSidr9+xJ7+td91XQ1+kzrZ+ts=";
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
    hyprgraphics
    hyprlang
    hyprutils
    libdrm
    libGL
    libjpeg
    libwebp
    libxkbcommon
    libgbm
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
