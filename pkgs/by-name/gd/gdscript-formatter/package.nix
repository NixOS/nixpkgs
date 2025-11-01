{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gdscript-formatter";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "GDQuest";
    repo = "GDScript-formatter";
    tag = finalAttrs.version;
    hash = "sha256-cY6Ow1f8o40M9/knneAod8ABj7ObQAkzs3yODMpkCxQ=";
    # Needed due to .gitattributes being used for the Godot addon and export-ignoring all files
    deepClone = true;
  };

  cargoHash = "sha256-U3M1xuSybP9WVHNMYaY6QrBZ//cAGCIOIo2dY0jpJzc=";

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
