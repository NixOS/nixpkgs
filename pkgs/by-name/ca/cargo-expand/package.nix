{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-expand";
<<<<<<< HEAD
  version = "1.0.119";
=======
  version = "1.0.118";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = "cargo-expand";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-N48BUPnVnMJSiM3EzpSiDNLGZNWFW05toHRhokNO5gI=";
  };

  cargoHash = "sha256-a8swmPQ+JuE/tqRYbV+kekZV8TloxszYq9k8VOGRBrM=";

  nativeInstallCheckInputs = [ versionCheckHook ];
=======
    hash = "sha256-+n4eiwcToXtWMPmvE41kOcZHzgugjekxQkodDagDjhI=";
  };

  cargoHash = "sha256-Di7Nnp8qYqpTkKmmUYoKxSkntepG80vVF2AkaN5yW+U=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cargo subcommand to show result of macro expansion";
    homepage = "https://github.com/dtolnay/cargo-expand";
    changelog = "https://github.com/dtolnay/cargo-expand/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      xrelkd
      defelo
    ];
    mainProgram = "cargo-expand";
  };
})
