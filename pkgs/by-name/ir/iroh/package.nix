{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "iroh";
  version = "0.94.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "iroh";
    rev = "v${version}";
    hash = "sha256-dWak0fSQi1tZ8hTG7aJ4dH9iTPQXNqS/Fe45XCnIBzA=";
  };

  cargoHash = "sha256-Z6Mn6KNweu2lGoDfjQeRambbDvxdGUgE35T496xMUGs=";

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
