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
  version = "2025.08.25.00";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "reindeer";
    tag = "v${version}";
    hash = "sha256-lrDfufxABC4noqHvG6vt2AjWI+O2pPrJLki67GnrB24=";
  };

  cargoHash = "sha256-7szjy2scCSedkHahWOCIxMrDh7f+nWYpK8BpKT6P9tE=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Generate Buck build rules from Rust Cargo dependencies";
    mainProgram = "reindeer";
    homepage = "https://github.com/facebookincubator/reindeer";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ nickgerace ];
  };
}
