{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  pkg-config,
  boost,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "floresta";
  version = "0.9.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "getfloresta";
    repo = "Floresta";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8GXCHvk6xxT93c073W15L0+xpri8lQvIcIdDcPead8I=";
  };

  cargoHash = "sha256-6xsCBw1rO36crFsAaJz42zHpbWju3umr1ppbflJ4uG8=";

  nativeBuildInputs = [
    cmake
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    boost
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
    homepage = "https://github.com/getfloresta/Floresta";
    changelog = "https://github.com/getfloresta/Floresta/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "florestad";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ starius ];
  };
})
