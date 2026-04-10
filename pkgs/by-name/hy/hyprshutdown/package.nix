{
  lib,
  gcc15Stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  hyprtoolkit,
  hyprutils,
  pixman,
  libdrm,
  glaze,
  aquamarine,
  hyprgraphics,
  cairo,
  nix-update-script,
  versionCheckHook,
}:

gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprshutdown";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprshutdown";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dp5lyZzKsjdqJLfwr0S4ILets8eu1kLfBB2y/LxspsU=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    hyprtoolkit
    hyprutils
    pixman
    libdrm
    aquamarine
    hyprgraphics
    cairo
    (glaze.override { enableSSL = false; })
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--help";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "A graceful shutdown utility for Hyprland";
    homepage = "https://github.com/hyprwm/hyprshutdown";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.mithicspirit ];
    teams = [ lib.teams.hyprland ];
    mainProgram = "hyprshutdown";
    platforms = lib.platforms.linux;
  };
})
