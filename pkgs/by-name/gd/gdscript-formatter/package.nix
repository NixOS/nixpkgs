{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gdscript-formatter";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "GDQuest";
    repo = "GDScript-formatter";
    tag = finalAttrs.version;
    hash = "sha256-16ASwYNnAtOVB0xxomjyuopya5rtmZriOE4H4W1v6nE=";
    # Needed due to .gitattributes being used for the Godot addon and export-ignoring all files
    deepClone = true;
  };

  cargoHash = "sha256-HWPSZFe78+NjIV79Un2e06S4AKpw1xJbJuX0fh1YJdo=";

  cargoBuildFlags = [
    "--bin=gdscript-formatter"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast code formatter for GDScript and Godot 4";
    homepage = "https://github.com/GDQuest/GDScript-formatter";
    changelog = "https://github.com/GDQuest/GDScript-formatter/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "gdscript-formatter";
    maintainers = with lib.maintainers; [ squarepear ];
  };
})
