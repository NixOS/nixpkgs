{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "floresta";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "vinteumorg";
    repo = "Floresta";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uiWK4w1Nm09CettJMjUgetXR3ysnVPwsQwx3AybV+Aw=";
  };

  cargoHash = "sha256-Wxg1BuLYXDJ6GwDKYbZL8577KiP21Jw59IXxrORzjY4=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  cargoBuildFlags = [
    "--package"
    "florestad"
    "--package"
    "floresta-cli"
  ];
  cargoInstallFlags = finalAttrs.cargoBuildFlags;

  # Tests rely on external services (bitcoind).
  doCheck = false;

  strictDeps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fully-validating Utreexo-based lightweight Bitcoin node with Electrum server";
    homepage = "https://github.com/vinteumorg/Floresta";
    changelog = "https://github.com/vinteumorg/Floresta/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "florestad";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ starius ];
  };
})
