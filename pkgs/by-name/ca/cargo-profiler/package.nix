{ fetchFromGitHub
, lib
, rustPlatform }:

let
  # Constants
  pname = "cargo-profiler";
  owner = "svenstaro";

  # Version-specific variables
  version = "0.2.0";
  rev = "0a8ab772fd5c0f1579e4847c5d05aa443ffa2bc8";
  sha256 = "sha256-ZRAbvSMrPtgaWy9RwlykQ3iiPxHCMh/tS5p67/4XqqA=";
  cargoSha256 = "sha256-qt3S6ZcLEP9ZQoP5+kSQdmBlxdMgGUqLszdU7JkFNVI=";

  inherit (rustPlatform) buildRustPackage;
in buildRustPackage rec {
  inherit pname version;

  src = fetchFromGitHub {
    inherit owner rev sha256;
    repo = pname;
  };

  inherit cargoSha256;

  meta = with lib; {
    description = "Cargo subcommand for profiling Rust binaries";
    mainProgram = "cargo-profiler";
    homepage = "https://github.com/svenstaro/cargo-profiler";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}
