{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "clorinde";
<<<<<<< HEAD
  version = "1.2.0";
=======
  version = "1.1.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "halcyonnouveau";
    repo = "clorinde";
    tag = "clorinde-v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-d+fVk3ZWccw/E6/mAyiGkP5t5/nl3riBAHwhzsaLiDs=";
  };

  cargoHash = "sha256-bu31l7slpWIHe2Ze/pP2udygt/KeWrdh0MYkCXCSWIc=";
=======
    hash = "sha256-a44y0cVmpQf3AmN4DXR50pFhUrWlANN9X0v0zQttT7M=";
  };

  cargoHash = "sha256-YSyHp3JwsLO7yrLko5NE2lb6ozy8Ah9i2Rz3854ujh0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  cargoBuildFlags = [ "--package=clorinde" ];

  cargoTestFlags = finalAttrs.cargoBuildFlags;

  nativeInstallCheckInputs = [ versionCheckHook ];
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "clorinde-v(.*)"
    ];
  };

  meta = {
    description = "Generate type-checked Rust from your PostgreSQL";
    homepage = "https://github.com/halcyonnouveau/clorinde";
    changelog = "https://github.com/halcyonnouveau/clorinde/blob/clorinde-v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "clorinde";
  };
})
