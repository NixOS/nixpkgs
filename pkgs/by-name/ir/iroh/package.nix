{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "iroh";
  version = "0.92.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "iroh";
    rev = "v${version}";
    hash = "sha256-Xdiw77zJd0WfrEqo4Y6BwyD9qAKFEIUS511CQvtU9xs=";
  };

  cargoHash = "sha256-Bq53DOZZ+MJlzJVHL6uPAH/YXkeSFFHhTlC2ZkvW7FM=";

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
