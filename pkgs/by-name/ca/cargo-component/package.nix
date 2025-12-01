{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-component";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "cargo-component";
    rev = "v${version}";
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

  meta = with lib; {
    description = "Cargo subcommand for creating WebAssembly components based on the component model proposal";
    homepage = "https://github.com/bytecodealliance/cargo-component";
    changelog = "https://github.com/bytecodealliance/cargo-component/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = [ maintainers.progrm_jarvis ];
    mainProgram = "cargo-component";
  };
}
