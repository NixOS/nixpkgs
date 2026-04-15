{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "reindeer";
  version = "2026.02.23.00";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "reindeer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m2IqtOzkrKhFfpwNX1KGW2HZz9DLskGXHum8mc4SVuc=";
  };

  cargoHash = "sha256-fWpxIQJOcqzUwHNID+Wc+3QOY9P9hIAYSb9wP8x4pVU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate Buck build rules from Rust Cargo dependencies";
    mainProgram = "reindeer";
    homepage = "https://github.com/facebookincubator/reindeer";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ amaanq ];
  };
})
