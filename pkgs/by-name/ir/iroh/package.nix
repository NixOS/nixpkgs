{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "iroh";
  version = "0.34.1";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "iroh";
    rev = "v${version}";
    hash = "sha256-kOqmkuKOP2dWrUVaGwHckWjaFVZkSoXqqUgn+2KaWkc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-O/j+/sRyMtqd4GaER2trn9SEFpZuSlc5q1MTXU+rwLg=";

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
