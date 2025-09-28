{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "mhost";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "lukaspustina";
    repo = "mhost";
    rev = "v${version}";
    sha256 = "sha256-6jn9jOCh96d9y2l1OZ5hgxg7sYXPUFzJiiT95OR7lD0=";
  };

  cargoHash = "sha256-n+ZVsdR+X7tMqZFYsjsWSUr6OkD90s44EFORqRldCNE=";

  CARGO_CRATE_NAME = "mhost";

  doCheck = false;

  meta = with lib; {
    description = "Modern take on the classic host DNS lookup utility including an easy to use and very fast Rust lookup library";
    homepage = "https://github.com/lukaspustina/mhost";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = [ maintainers.mgttlinger ];
    mainProgram = "mhost";
  };
}
