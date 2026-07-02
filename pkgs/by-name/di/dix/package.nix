{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dix";
  version = "2.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = "dix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+9I6WuPOc8Lj7NAxe19phlFiDypGQywopZ3dZK9d6F4=";
  };

  cargoHash = "sha256-k/of0KX2wBWh/etybbKn81O5UgJF0ylc2fl+HK8uIRQ=";

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
