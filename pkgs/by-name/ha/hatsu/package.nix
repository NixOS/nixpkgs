{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "hatsu";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "importantimport";
    repo = "hatsu";
    tag = "v${version}";
    hash = "sha256-mqs26srbEkGeQzeF4OdqI7o18Ajs+mmAXGLlVfS52sk=";
  };

  cargoHash = "sha256-5c6boVdq0XXbtVHqmIGoxJGQRh8lvn2jbmALPuOSMs4=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Self-hosted and fully-automated ActivityPub bridge for static sites";
    homepage = "https://github.com/importantimport/hatsu";
    changelog = "https://github.com/importantimport/hatsu/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    mainProgram = "hatsu";
    maintainers = with lib.maintainers; [ kwaa ];
    platforms = lib.platforms.linux;
  };
}
