{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-machete";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "bnjbvr";
    repo = "cargo-machete";
    rev = "v${version}";
    hash = "sha256-qOWa2Q7B073b5UssRnUkk24+PkIzl+czWGCcORUc55w=";
  };

  cargoHash = "sha256-q5oC2leWjsCFrwJ9ITeEjxtnnvfDrGyyKNR4kAXBQ6Q=";

  # tests require internet access
  doCheck = false;

  meta = with lib; {
    description = "Cargo tool that detects unused dependencies in Rust projects";
    mainProgram = "cargo-machete";
    homepage = "https://github.com/bnjbvr/cargo-machete";
    changelog = "https://github.com/bnjbvr/cargo-machete/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
