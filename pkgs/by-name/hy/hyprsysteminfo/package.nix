{
  lib,
  gcc16Stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  glaze,
  hyprtoolkit,
  pciutils,
}:
gcc16Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprsysteminfo";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprsysteminfo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xq8TlF1ZuHUs2t6eMe4jgbOmNJZynE3rke8KhEY8U+A=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    (glaze.override { enableSSL = false; })
    hyprtoolkit
    pciutils
  ];

  meta = {
    description = "System info utility for Hyprland";
    homepage = "https://github.com/hyprwm/hyprsysteminfo";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.hyprland ];
    mainProgram = "hyprsysteminfo";
    platforms = lib.platforms.linux;
  };
})
