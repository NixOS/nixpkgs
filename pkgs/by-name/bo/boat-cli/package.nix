{
  lib,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  rustPlatform,
  sqlite,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "boat-cli";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "coko7";
    repo = "boat-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oS+NfEQKAcfZwYQkftMJAUz7fG1nleruAROMUUbBP3Y=";
  };

  cargoHash = "sha256-mHqXIFI2KJOMnxdG3X4DHDozFDPmqw4f//ori3Dc7us=";

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    sqlite
  ];

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Basic Opinionated Activity Tracker, a command line interface inspired by bartib.";
    homepage = "https://github.com/coko7/boat-cli";
    changelog = "https://github.com/coko7/boat-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tgi74 ];
    mainProgram = "boat";
  };
})
