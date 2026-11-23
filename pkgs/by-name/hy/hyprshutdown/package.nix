{
  lib,
  gcc16Stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  hyprtoolkit,
  glaze,
  nix-update-script,
  versionCheckHook,
}:

gcc16Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprshutdown";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprshutdown";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0EIGGy6ARdYjzm8vQncIxFbsLAxt6QK28ZJA44IoGWI=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    hyprtoolkit
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
    changelog = "https://github.com/hyprwm/hyprshutdown/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.mithicspirit ];
    teams = [ lib.teams.hyprland ];
    mainProgram = "hyprshutdown";
    platforms = lib.platforms.linux;
  };
})
