{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "prmt";
<<<<<<< HEAD
  version = "0.2.2";
=======
  version = "0.1.7";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    repo = "prmt";
    owner = "3axap4eHko";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-n5Tq6fnImE744/QaQzkqrRsqk76YNrQUp8/cOEly06I=";
  };

  cargoHash = "sha256-6meuA7D5JoSvG9aAGy+rglt66qckvJBn0FhmYFAiTdA=";
=======
    hash = "sha256-CLSBthofkVdNE/ayecTRLtFDxtGesDuEGw1/Jutpu+c=";
  };

  cargoHash = "sha256-0TYjXpR3VyRdI+3ZIPnoaM1Mod0rXOinpByeOduKSdk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # Fail to run in sandbox environment
  checkFlags = map (t: "--skip ${t}") [
    "modules::path::tests::relative_path_inside_home_renders_tilde"
    "modules::path::tests::relative_path_with_shared_prefix_is_not_tilde"
    "test_git_module"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Ultra-fast, customizable shell prompt generator";
    homepage = "https://github.com/3axap4eHko/prmt";
    changelog = "https://github.com/3axap4eHko/prmt/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "prmt";
  };
})
