{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libGL
, libxkbcommon
, hyprlang
, pam
, wayland
, wayland-protocols
, cairo
, pango
, libdrm
, mesa
, nix-update-script
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprlock";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprlock";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rbzVe2WNdHynJrnyJsKOOrV8yuuJ7QIuah3ZHWERSnA=";
  };

  patches = [
    # remove PAM file install check
    ./cmake.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    cairo
    hyprlang
    libdrm
    libGL
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
    maintainers = with lib.maintainers; [ eclairevoyant ];
    mainProgram = "hyprlock";
    platforms = [ "aarch64-linux" "x86_64-linux" ];
  };
})
