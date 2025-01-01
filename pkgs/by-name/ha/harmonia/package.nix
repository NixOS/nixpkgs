{
  lib,
  fetchFromGitHub,
  libsodium,
  openssl,
  pkg-config,
  rustPlatform,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "harmonia";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "harmonia";
    rev = "refs/tags/harmonia-v${version}";
    hash = "sha256-tqkTzUdwnTfVuCrcFag7YKgGkiR9srR45e4v0XMXVCY=";
  };

  cargoHash = "sha256-iZbIuYSC/RLmYEhBu46EEzN+WG2RoUJbZegedXkh+Rg=";

  doCheck = false;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libsodium
    openssl
  ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "harmonia-v(.*)"
      ];
    };
    tests = { inherit (nixosTests) harmonia; };
  };

  meta = with lib; {
    description = "Nix binary cache";
    homepage = "https://github.com/nix-community/harmonia";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    mainProgram = "harmonia";
  };
}
