{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-mutants";
  version = "25.0.0";

  src = fetchFromGitHub {
    owner = "sourcefrog";
    repo = "cargo-mutants";
    rev = "v${version}";
    hash = "sha256-JwRMXFXYXPg/grFqeGIcWpDPI5/wFIldx4ORE8ODyk8=";
  };

  cargoHash = "sha256-8sAyQ858brL6EFW8gRAPrlpSPW7lYrd4dFOyUDOnIaU=";

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
