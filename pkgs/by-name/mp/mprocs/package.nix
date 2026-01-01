{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

<<<<<<< HEAD
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mprocs";
  version = "0.8.2";
=======
rustPlatform.buildRustPackage rec {
  pname = "mprocs";
  version = "0.7.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "pvolok";
    repo = "mprocs";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
    hash = "sha256-77uXHlQjhIDbRbnkr3jvZKuLOcvbOIuum8FRsUv8cYw=";
  };

  cargoHash = "sha256-T8zG2Z7UP4MZUGeUypG9ugO49rbicwYrdRZiGJN3H0E=";
=======
    tag = "v${version}";
    hash = "sha256-/FuvejcZoaHzlYh4zYDVS1WimzNMNbRZyM39OBi02VA=";
  };

  cargoHash = "sha256-i9oQT2vpA5nAgQgVpxxfRPvCIb4w1emt1YsjMS6UPIk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "TUI tool to run multiple commands in parallel and show the output of each command separately";
    homepage = "https://github.com/pvolok/mprocs";
<<<<<<< HEAD
    changelog = "https://github.com/pvolok/mprocs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.unix;
    mainProgram = "mprocs";
  };
})
=======
    changelog = "https://github.com/pvolok/mprocs/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      GaetanLepage
      pyrox0
    ];
    platforms = lib.platforms.unix;
    mainProgram = "mprocs";
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
