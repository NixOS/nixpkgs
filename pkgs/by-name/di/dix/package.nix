{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dix";
  version = "2.0.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = "dix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KTlFgBEVKJIXymfN2UU8hvGM71PYRcNgJ1XWUmG2AI4=";
  };

  cargoHash = "sha256-pNkSdsxOpv0E/xXs7tMg2vtP0PBU7p8fh3H4IX/u5k4=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/manic-systems/dix";
    description = "Blazingly fast tool to diff Nix related things";
    changelog = "https://github.com/manic-systems/dix/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [
      faukah
      NotAShelf
    ];
    mainProgram = "dix";
  };
})
