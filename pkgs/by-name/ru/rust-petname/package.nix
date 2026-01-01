{
  lib,
  rustPlatform,
  fetchCrate,
<<<<<<< HEAD
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
=======
}:

rustPlatform.buildRustPackage rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "rust-petname";
  version = "2.0.2";

  src = fetchCrate {
<<<<<<< HEAD
    inherit (finalAttrs) version;
=======
    inherit version;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    crateName = "petname";
    hash = "sha256-KP+GdGlwLHcKE8nAmFr2wHbt5RD9Ptpiz1X5HgJ6BgU=";
  };

  cargoHash = "sha256-gZxZeirvGHwm8C87HdCBYr30+0bbjwnWxIQzcLgl3iQ=";

<<<<<<< HEAD
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate human readable random names";
    homepage = "https://github.com/allenap/rust-petname";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.progrm_jarvis ];
    mainProgram = "petname";
  };
})
=======
  meta = with lib; {
    description = "Generate human readable random names";
    homepage = "https://github.com/allenap/rust-petname";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "petname";
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
