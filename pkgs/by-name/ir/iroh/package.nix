{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "iroh";
  version = "0.93.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "iroh";
    rev = "v${version}";
    hash = "sha256-GTvplzx+F5vGWaqgp4YhjcuKUvLysMoHQceVQ6l2an4=";
  };

  cargoHash = "sha256-Ss/JJZUGYXuNH9jtqJTi9/OrAd4Ot4z0bp9qkPg+ZrA=";

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
