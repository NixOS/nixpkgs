{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "subxt";
  version = "0.51.1";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "subxt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/bM/GhLVpaWemrm1gCDzsvg0jU4cKvH57PFXwLHbddg=";
  };

  cargoHash = "sha256-2CuEDDdnrs4zN/uvhRhbUvuVHgBJqIhl12hLBUXixgg=";

  # Only build the command line client
  cargoBuildFlags = [
    "--bin"
    "subxt"
  ];

  # Requires a running substrate node
  doCheck = false;

  __structuredAttrs = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  # subxt exposes its version through a subcommand, not a --version flag
  versionCheckProgramArg = "version";

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/paritytech/subxt";
    description = "Subxt is a CLI tool for interacting with chains in the Polkadot network";
    changelog = "https://github.com/paritytech/subxt/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "subxt";
    license = with lib.licenses; [
      gpl3Plus
      asl20
    ];
    maintainers = with lib.maintainers; [
      FlorianFranzen
      kilyanni
    ];
  };
})
