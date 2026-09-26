{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sampo";
  version = "0.20.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bruits";
    repo = "sampo";
    tag = "cargo-sampo-v${finalAttrs.version}";
    hash = "sha256-cs/0+IEqVQAgg+OTnKB/Ava4J5zPs+Lp/bYNnPgAuwI=";
  };

  cargoHash = "sha256-pfg+Oa7sGyzBd/vCK5IEiCt2g6lC5V9WeSjpCnE+/n4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

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
