{
  lib,
  gcc16Stdenv,
  cmake,
  pkg-config,
  fetchFromGitHub,
  hyprutils,
  hyprtoolkit,
  hyprgraphics,
  hyprlang,
  aquamarine,
  pixman,
  libdrm,
  sdbus-cpp_2,
  polkit,
  systemd,
  cairo,
  pango,
  libxkbcommon,
}:
gcc16Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprpolkitagent";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprpolkitagent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ygn+TD4GI3jSKCBNohgITdSicAgMCDq1lJzNN5QR/5o=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    hyprutils
    hyprtoolkit
    hyprgraphics
    hyprlang
    aquamarine
    pixman
    libdrm
    sdbus-cpp_2
    polkit
    systemd
    cairo
    pango
    libxkbcommon
  ];

  meta = {
    description = "Polkit authentication agent built with hyprtoolkit";
    homepage = "https://github.com/hyprwm/hyprpolkitagent";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.hyprland ];
    mainProgram = "hyprpolkitagent";
    platforms = lib.platforms.linux;
  };
})
