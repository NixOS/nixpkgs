{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "slumber";
<<<<<<< HEAD
  version = "4.3.0";
=======
  version = "4.2.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "LucasPickering";
    repo = "slumber";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-wQ7TKH/nIoTF+l1U7nP47VDb6Ck1pgofF6tFXpcyaeU=";
  };

  cargoHash = "sha256-0gwIQQFkIdAla9X1HFdDtV0OUgtKAvB5a1S36iF8j+Y=";
=======
    hash = "sha256-wEQPyp0J7p2TuJwH/fQv5fhenUY3MNIq0oazFJAj9lM=";
  };

  cargoHash = "sha256-Nz/Z2KJ8jJAsTASwnvleRpJ88UHGe7dktO0FkCOPdu4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal-based HTTP/REST client";
    homepage = "https://slumber.lucaspickering.me";
    changelog = "https://github.com/LucasPickering/slumber/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "slumber";
    maintainers = with lib.maintainers; [ javaes ];
  };
})
