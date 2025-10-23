{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

let
  # Constants
  pname = "cargo-profiler";
  owner = "svenstaro";

  # Version-specific variables
  version = "0.2.0";
  rev = "0a8ab772fd5c0f1579e4847c5d05aa443ffa2bc8";
  hash = "sha256-ZRAbvSMrPtgaWy9RwlykQ3iiPxHCMh/tS5p67/4XqqA=";
  cargoHash = "sha256-GrHH98jcJaEkCzHe1hoVAeZvTvE0kXdp0bPTIiiOYss=";

  inherit (rustPlatform) buildRustPackage;
in
buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    inherit owner rev hash;
    repo = "cargo-profiler";
  };

  inherit cargoHash;

  meta = with lib; {
    description = "Cargo subcommand for profiling Rust binaries";
    mainProgram = "cargo-profiler";
    homepage = "https://github.com/svenstaro/cargo-profiler";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}
