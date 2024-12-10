{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "reindeer";
  version = "2024.10.28.00";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "reindeer";
    rev = "refs/tags/v${version}";
    hash = "sha256-1wbw92dZT5SVXgfWMgXd3asHhilVzH4lvqW60hTznVc=";
  };

  cargoHash = "sha256-OjA0OKotAdRLGRkl8n3Gn2+Z8JVcGjQYHtOszWnnFdM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Reindeer is a tool which takes Rust Cargo dependencies and generates Buck build rules";
    mainProgram = "reindeer";
    homepage = "https://github.com/facebookincubator/reindeer";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ nickgerace ];
  };
}
