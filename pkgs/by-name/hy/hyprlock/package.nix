{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libGL,
  libxkbcommon,
  hyprlang,
  pam,
  wayland,
  wayland-protocols,
  cairo,
  file,
  libjpeg,
  libwebp,
  pango,
  libdrm,
  mesa,
  hyprutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprlock";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprlock";
    rev = "6e0921140efb8895eb98efa99438fff23df2a726";
    hash = "sha256-Dd/DK6FKiwVhr6PygCieEjzn7AFf6xijw6mdhquLnkw=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
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
    wayland
    wayland-protocols
  ];

  meta = {
    description = "Hyprland's GPU-accelerated screen locking utility";
    homepage = "https://github.com/hyprwm/hyprlock";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "hyprlock";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
})
