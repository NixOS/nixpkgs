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
  version = "2026.08.17.00";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "reindeer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3PoNc6mhXc/gc3JaKT6RvfZ82Um2BYiL0E+QxiiEc6w=";
  };

  cargoHash = "sha256-IWYhr+A18UeeKccJ5Bh4eNuq3ZopKyROOBDepgWEYv4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate Buck build rules from Rust Cargo dependencies";
    mainProgram = "reindeer";
    homepage = "https://github.com/facebookincubator/reindeer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ amaanq ];
  };
})
