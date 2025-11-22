{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gdscript-formatter";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "GDQuest";
    repo = "GDScript-formatter";
    tag = finalAttrs.version;
    hash = "sha256-DO8ctTmPUkB+XZ1iEkv3HLWprCH6IHdGXIWvn08PL+A=";
    # Needed due to .gitattributes being used for the Godot addon and export-ignoring all files
    deepClone = true;
  };

  cargoHash = "sha256-b1seQakW2hZkclzkXX7DcTn+8TLinl2h0XMmdLHUT1A=";

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
