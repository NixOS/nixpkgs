{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-mutants";
  version = "25.2.0";

  src = fetchFromGitHub {
    owner = "sourcefrog";
    repo = "cargo-mutants";
    rev = "v${version}";
    hash = "sha256-//OUOf4RUM69tHBB17p4OSs/cCvv0HnDjyRUzUZc8KE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-QZrpH0nJ6a9AQAKNp/tkT1hpkUMWa2kh8kek2rY8wO4=";

  # too many tests require internet access
  doCheck = false;

  meta = with lib; {
    description = "Mutation testing tool for Rust";
    mainProgram = "cargo-mutants";
    homepage = "https://github.com/sourcefrog/cargo-mutants";
    changelog = "https://github.com/sourcefrog/cargo-mutants/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
