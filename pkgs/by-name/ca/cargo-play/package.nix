{
  lib,
  rustPlatform,
  fetchFromGitHub,
<<<<<<< HEAD
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
=======
}:

rustPlatform.buildRustPackage rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "cargo-play";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "fanzeyi";
    repo = "cargo-play";
<<<<<<< HEAD
    tag = finalAttrs.version;
=======
    tag = version;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    sha256 = "sha256-Z5zcLQYfQeGybsnt2U+4Z+peRHxNPbDriPMKWhJ+PeA=";
  };

  cargoHash = "sha256-kgdg2GZmFGMua3eYo30tpDTFBKncbaiONJf+ocfMaBk=";

  # these tests require internet access
  checkFlags = [
    "--skip=dtoa_test"
    "--skip=infer_override"
  ];

<<<<<<< HEAD
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Run your rust code without setting up cargo";
    mainProgram = "cargo-play";
    homepage = "https://github.com/fanzeyi/cargo-play";
    changelog = "https://github.com/fanzeyi/cargo-play/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.progrm_jarvis ];
  };
})
=======
  meta = with lib; {
    description = "Run your rust code without setting up cargo";
    mainProgram = "cargo-play";
    homepage = "https://github.com/fanzeyi/cargo-play";
    license = licenses.mit;
    maintainers = [ ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
