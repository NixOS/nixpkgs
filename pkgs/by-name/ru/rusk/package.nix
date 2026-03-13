{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rusk";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "tagirov";
    repo = "rusk";
    tag = finalAttrs.version;
    hash = "sha256-Hu/Z7sFle1EEyfoSKKf9pppazfSz8MqVz9Wyvs7SyfM=";
  };

  cargoHash = "sha256-ZUI/TBuC1Oih6LlFqvWhJKIfe/RMEyixY7MWGkHtmZA=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  doCheck = false; # FIXME: https://github.com/tagirov/rusk/issues/8

  meta = {
    description = "Minimal terminal task manager";
    homepage = "https://github.com/tagirov/rusk";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "rusk";
  };
})
