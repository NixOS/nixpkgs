{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "iroh";
  version = "0.90.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "iroh";
    rev = "v${version}";
    hash = "sha256-0YXNPKdM9OQC+MiKQzki5FmVMbCRO1l02ik+uRi90aQ=";
  };

  cargoHash = "sha256-tt2SHvL/S82jzzaO5e95vQvwJSgJpUh2dDIgLhs1V5w=";

  # Some tests require network access which is not available in nix build sandbox.
  doCheck = false;

  meta = with lib; {
    description = "Efficient IPFS for the whole world right now";
    homepage = "https://iroh.computer";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ cameronfyfe ];
    mainProgram = "iroh";
  };
}
