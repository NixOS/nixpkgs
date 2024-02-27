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
, expat
, libXdmcp
, pcre2
, util-linux
, libselinux
, libsepol
, pcre
, fribidi
, libthai
, libdatrie
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprlock";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprlock";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SX3VRcewkqeAIY6ptgfk9+C6KB9aCEUOacb2pKl3kO0=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    cairo
    expat
    fribidi
    hyprlang
    libdatrie
    libdrm
    libGL
    libselinux
    libsepol
    libthai
    libXdmcp
    libxkbcommon
    mesa
    pam
    pango
    pcre
    pcre2
    util-linux
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
