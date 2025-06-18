{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "iroh";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "iroh";
    rev = "v${version}";
    hash = "sha256-D/f/x8fv29O9rxJ/TuYc0myI/TDORkF88QwTkoZXXbg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-hY8WSd/B9wmgjjq+2wb1Kki07dt4TxY5tWR/m9w/IDA=";

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
