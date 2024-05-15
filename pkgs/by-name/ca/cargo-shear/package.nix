{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-shear";
  version = "0.0.25";

  src = fetchFromGitHub {
    owner = "Boshen";
    repo = "cargo-shear";
    rev = "v${version}";
    sha256 = "sha256-4NnCUe4DrnSeveicxvvDF49hrc4NdRx/N10PH7Q0k8k=";
  };

  cargoHash = "sha256-gHXJz3Xw9vC04q001kd6AgEKKaRtAK3oGMn7JJh+Neo=";

  meta = with lib; {
    description = "Detect and remove unused dependencies from Cargo.toml";
    mainProgram = "cargo-shear";
    homepage = "https://github.com/Boshen/cargo-shear";
    changelog = "https://github.com/Boshen/cargo-shear/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ uncenter ];
  };
}
