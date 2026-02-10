{
  fetchFromGitHub,
  lib,
  perl,
  pkg-config,
  openssl,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "screenly-cli";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "screenly";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Icx0Nkn0ScbNTmXllkUj6DPhGqzh8HnIQPpej4ABJac=";
  };

  cargoHash = "sha256-XYXWbwuoPqL93R8Bre26kBPxkiXpJ0Dg06cBOyDK8ok=";

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tools for managing digital signs and screens at scale";
    homepage = "https://github.com/Screenly/cli";
    changelog = "https://github.com/Screenly/cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "screenly";
    maintainers = with lib.maintainers; [
      vpetersson
    ];
  };
})
