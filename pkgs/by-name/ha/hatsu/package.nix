{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "hatsu";
<<<<<<< HEAD
  version = "0.3.4";
=======
  version = "0.3.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "importantimport";
    repo = "hatsu";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-66BNgcCYPMJ5AE/OCfbLrU+A/usv0/QvcyPy8D+7PVs=";
  };

  cargoHash = "sha256-NXauXnCpk8YjiX4bqZMbEy/QPb7MiJYzY64YKDV6qq0=";

  nativeInstallCheckInputs = [ versionCheckHook ];
=======
    hash = "sha256-mqs26srbEkGeQzeF4OdqI7o18Ajs+mmAXGLlVfS52sk=";
  };

  cargoHash = "sha256-5c6boVdq0XXbtVHqmIGoxJGQRh8lvn2jbmALPuOSMs4=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
