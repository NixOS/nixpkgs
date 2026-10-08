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
  version = "2026.09.28.00";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "reindeer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ruOXPHqLJfk/Y6EHssb4wF1iFHgVKPmjJ6ydtU2hE44=";
  };

  cargoHash = "sha256-WMzXFVdl80PREiRG1uP+dPBEr5So9eV/gg1g+AeGDLc=";

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
