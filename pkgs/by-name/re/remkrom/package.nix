{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "remkrom";
  version = "0-unstable-2020-10-17";

  src = fetchFromGitHub {
    owner = "siraben";
    repo = "remkrom";
    rev = "86a0b19c1d382a029ecaa96eeca7e9f76c8561d6";
    sha256 = "sha256-DhfNfV9bd0p5dLXKgrVLyugQHK+RHsepeg0tGq5J6cI=";
  };

  cargoHash = "sha256-H+SZ+aUQReFJiN2MQHxaI0/bM1sXaSFVlIhedCKBQ0M=";

  meta = {
    description = "Reimplementation of mkrom in Rust";
    homepage = "https://github.com/siraben/remkrom";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siraben ];
    mainProgram = "remkrom";
  };
}
