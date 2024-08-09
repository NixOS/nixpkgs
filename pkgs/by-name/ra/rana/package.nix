{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "rana";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "grunch";
    repo = "rana";
    rev = "refs/tags/v${version}";
    hash = "sha256-NgbWRuwD+nfNbB6WRbDjUPJneysb85z5eqXmU31U6Mo=";
  };

  cargoHash = "sha256-FMJisCR1bomswFHjIIu/24ywvQn1pv/7QHiEmaBV4a8=";

  meta = {
    description = "Nostr public key mining tool";
    homepage = "https://github.com/grunch/rana";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jigglycrumb ];
    mainProgram = "rana";
  };
}
