{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
<<<<<<< HEAD
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
=======
}:

rustPlatform.buildRustPackage rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "cargo-component";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "cargo-component";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
=======
    rev = "v${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    hash = "sha256-Tlx14q/2k/0jZZ1nECX7zF/xNTeMCZg/fN+fhRM4uhc=";
  };

  cargoHash = "sha256-ZwxVhoqAzkaIgcH9GMR+IGkJ6IOQVtmt0qcDjdix6cU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  # requires the wasm32-wasi target
  doCheck = false;

<<<<<<< HEAD
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cargo subcommand for creating WebAssembly components based on the component model proposal";
    homepage = "https://github.com/bytecodealliance/cargo-component";
    changelog = "https://github.com/bytecodealliance/cargo-component/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.progrm_jarvis ];
    mainProgram = "cargo-component";
  };
})
=======
  meta = with lib; {
    description = "Cargo subcommand for creating WebAssembly components based on the component model proposal";
    homepage = "https://github.com/bytecodealliance/cargo-component";
    changelog = "https://github.com/bytecodealliance/cargo-component/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "cargo-component";
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
