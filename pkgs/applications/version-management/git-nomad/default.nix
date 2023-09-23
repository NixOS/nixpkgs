{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin, git }:

rustPlatform.buildRustPackage rec {
  pname = "git-nomad";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "rraval";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KrxP2P62Dfx1ZBeYAuhUYdSxNG18I7PJTvbXBS93k2k=";
  };

  cargoHash = "sha256-eu/TAAJ8nsZkLgDKO4bVeNNjhTsz4lugHqhaSKrwyMc=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  nativeCheckInputs = [
    git
  ];

  meta = with lib; {
    description = "Synchronize work-in-progress git branches in a light weight fashion";
    homepage = "https://github.com/rraval/git-nomad";
    changelog = "https://github.com/rraval/git-nomad/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ rraval ];
  };
}
