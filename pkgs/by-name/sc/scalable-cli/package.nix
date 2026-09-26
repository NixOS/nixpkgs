{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "scalable-cli";
  version = "1.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ScalableCapital";
    repo = "scalable-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CFMA17VarZwyPDZmTWj3RWtGpIFEGtJzW8ez5D7jjR0=";
  };

  cargoHash = "sha256-O8ojroRxbR2rJUIcoyzol1UK0HUPjS6+3k1GDlIQxxs=";

  buildFeatures = [ "channel-prod" ];

  # Tests are written against internal dev-channel configuration and fail
  # when built with the channel-prod feature
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Scalable Capital CLI";
    homepage = "https://github.com/ScalableCapital/scalable-cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jonasfranke ];
    mainProgram = "sc";
    platforms = lib.platforms.linux;
  };
})
