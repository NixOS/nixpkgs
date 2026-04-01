{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "siomon";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "level1techs";
    repo = "siomon";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ox4J2YKTN2Hf51+gyl6TKiS/6HIMbgplwv73tVAHFd0=";
  };

  cargoHash = "sha256-PC8G/FQjIwdyUBtG6DBon/4ZseihrBUZ/L65Agh6hhY=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hardware information and real-time sensor monitoring tool for Linux";
    homepage = "https://github.com/level1techs/siomon";
    changelog = "https://github.com/level1techs/siomon/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ sheevy ];
    mainProgram = "sio";
  };
})
