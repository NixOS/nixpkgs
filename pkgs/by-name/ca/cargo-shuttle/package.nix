{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  zlib,
<<<<<<< HEAD
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
=======
}:

rustPlatform.buildRustPackage rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "cargo-shuttle";
  version = "0.57.3";

  src = fetchFromGitHub {
    owner = "shuttle-hq";
    repo = "shuttle";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
=======
    rev = "v${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    hash = "sha256-qPevl75wmOYVhTgMiJOi+6j8LBWKzM7HPhd5mdf2B+8=";
  };

  cargoHash = "sha256-H2fy2NQvLQEzbQik+nrUvoYZaWQRXX6PpO9LcYfiF2I=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    zlib
  ];

  cargoBuildFlags = [
    "-p"
    "cargo-shuttle"
  ];

<<<<<<< HEAD
  cargoTestFlags = finalAttrs.cargoBuildFlags ++ [
=======
  cargoTestFlags = cargoBuildFlags ++ [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    # other tests are failing for different reasons
    "init::shuttle_init_tests::"
  ];

<<<<<<< HEAD
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cargo command for the shuttle platform";
    mainProgram = "cargo-shuttle";
    homepage = "https://shuttle.rs";
    changelog = "https://github.com/shuttle-hq/shuttle/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.progrm_jarvis ];
  };
})
=======
  meta = with lib; {
    description = "Cargo command for the shuttle platform";
    mainProgram = "cargo-shuttle";
    homepage = "https://shuttle.rs";
    changelog = "https://github.com/shuttle-hq/shuttle/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
