{
  lib,
  gcc16Stdenv,
  cmake,
  pkg-config,
  fetchFromGitHub,
  hyprlang,
  hyprtoolkit,
  libxkbcommon,
  polkit,
  sdbus-cpp_2,
  systemd,
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
    hyprlang
    hyprtoolkit
    libxkbcommon
    polkit
    sdbus-cpp_2
    systemd
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
