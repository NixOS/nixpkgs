{
  lib,
  rustPlatform,
  fetchFromGitHub,
<<<<<<< HEAD
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kickstart";
  version = "0.6.0";
=======
  nix-update-script,
  testers,
  kickstart,
}:

rustPlatform.buildRustPackage rec {
  pname = "kickstart";
  version = "0.5.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Keats";
    repo = "kickstart";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
    hash = "sha256-WrImCnXkFaPUTMBhNaUgX6PsQS1H9zj6jZ8MbgYCGCM=";
  };

  cargoHash = "sha256-Km49POZwVS2vYmELG5f7kenKQwaHlMP/bZA5cZ995mE=";
=======
    rev = "v${version}";
    hash = "sha256-4POxv6fIrp+wKb9V+6Y2YPx3FXp3hpnkq+62H9TwGII=";
  };

  cargoHash = "sha256-J9sGXJbGbO9UgZfgqxqzbiJz9j6WMpq3qC2ys7OJnII=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  buildFeatures = [ "cli" ];

  checkFlags = [
    # remote access
    "--skip=generation::tests::can_generate_from_remote_repo_with_subdir"
    "--skip=generation::tests::can_generate_from_remote_repo"
  ];

<<<<<<< HEAD
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
=======
  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = kickstart;
    };
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  meta = {
    description = "Scaffolding tool to get new projects up and running quickly";
    homepage = "https://github.com/Keats/kickstart";
<<<<<<< HEAD
    changelog = "https://github.com/Keats/kickstart/releases/tag/${finalAttrs.src.tag}";
=======
    changelog = "https://github.com/Keats/kickstart/releases/tag/v${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gaelreyrol ];
    mainProgram = "kickstart";
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
