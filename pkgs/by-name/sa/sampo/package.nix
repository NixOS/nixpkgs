{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  pkg-config,
  openssl,
  aws-lc,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sampo";
  version = "0.24.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bruits";
    repo = "sampo";
    tag = "cargo-sampo-v${finalAttrs.version}";
    hash = "sha256-NSWM1LUghTavZd58G4hiJTQaZ3dpz1RqFm12Cc8WjY0=";
  };

  cargoHash = "sha256-Rmi9Opfgm5tX1HpKD+YyWaHpsShLEODyE+zOH5UyxTo=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    aws-lc
  ];

  # Disable self-update
  buildNoDefaultFeatures = true;

  cargoBuildFlags = [
    "-p"
    "sampo"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  env.OPENSSL_NO_VENDOR = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=cargo-sampo-v([0-9\\.]*)" ];
  };

  meta = {
    description = "Automate changelogs, versioning, and publishing—even for monorepos across multiple package registries";
    homepage = "https://github.com/bruits/sampo";
    changelog = "https://github.com/bruits/sampo/blob/${finalAttrs.src.tag}/crates/sampo/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "sampo";
  };
})
