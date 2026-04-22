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
  version = "0.17.4";

  src = fetchFromGitHub {
    owner = "bruits";
    repo = "sampo";
    tag = "sampo-v${finalAttrs.version}";
    hash = "sha256-P+CekuDM3u+iG2HmCNWxZoTCaKtAUMnrNre4zeGNPrQ=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  cargoHash = "sha256-udMpH0LWNqPTORSb1/c686stgvti5shx/O9rcH7YZNs=";

  cargoBuildFlags = [
    "-p"
    "sampo"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  env.OPENSSL_NO_VENDOR = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=sampo-v([0-9\\.]*)" ]; };

  meta = {
    description = "Automate changelogs, versioning, and publishing—even for monorepos across multiple package registries";
    homepage = "https://github.com/bruits/sampo";
    changelog = "https://github.com/bruits/sampo/blob/sampo-v${finalAttrs.version}/crates/sampo/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "sampo";
  };
})
