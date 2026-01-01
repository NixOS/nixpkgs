{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "harper";
<<<<<<< HEAD
  version = "1.3.0";
=======
  version = "0.71.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Automattic";
    repo = "harper";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-AXBRCQpa2cmdmVeABZb9hXNWH7gJgqfrqot16fTgJrY=";
=======
    hash = "sha256-Hf086Ub0nVGET4qELDMddOErGAhK8B6ohbI5JhnU6z8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  buildAndTestSubdir = "harper-ls";

<<<<<<< HEAD
  cargoHash = "sha256-LqjdH6qKpcMBy8Pqks4nmvej3wbT5EvIISxp9ULgqs4=";
=======
  cargoHash = "sha256-hS8fLWD3OTfEAa+4saeB9pK3zS/EQSnoQSUGIkVWocw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Grammar Checker for Developers";
    homepage = "https://github.com/Automattic/harper";
    changelog = "https://github.com/Automattic/harper/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      pbsds
      sumnerevans
      ddogfoodd
    ];
    mainProgram = "harper-ls";
  };
})
