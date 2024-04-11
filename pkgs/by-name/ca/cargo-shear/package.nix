{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-shear";
  version = "0.0.24";

  src = fetchFromGitHub {
    owner = "Boshen";
    repo = "cargo-shear";
    rev = "v${version}";
    sha256 = "sha256-7eBFDmeFOXqZhNE4RDlIq991xEoCGL6XLMmUQuLJvrE=";
  };

  cargoSha256 = "sha256-DQjLW6NtUPERT82zIlrGRk3FffU/EfLBMgAeFfFdDxE=";

  meta = with lib; {
    description = "Detect and remove unused dependencies from Cargo.toml";
    mainProgram = "cargo-shear";
    homepage = "https://github.com/Boshen/cargo-shear";
    changelog = "https://github.com/Boshen/cargo-shear/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ uncenter ];
  };
}
