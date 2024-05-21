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
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprlock";
  version = "0.3.0-unstable-2024-04-24";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprlock";
    # FIXME: Change to a stable release once available
    rev = "415262065fff0a04b229cd00165f346a86a0a73a";
    hash = "sha256-jla5Wo0Qt3NEnD0OjNj85BGw0pR4Zlz5uy8AqHH7tuE=";
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

  passthru.updateScript = nix-update-script { };

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
