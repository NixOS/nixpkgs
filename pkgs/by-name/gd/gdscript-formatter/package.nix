{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gdscript-formatter";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "GDQuest";
    repo = "GDScript-formatter";
    tag = finalAttrs.version;
    hash = "sha256-lr17ZX142o5aOIB+HRjM/MnB8P2QwLVV3vCM6QsQ+bU=";
    # Needed due to .gitattributes being used for the Godot addon and export-ignoring all files
    deepClone = true;
    # Avoid hash differences due to differences in .git
    leaveDotGit = false;
  };

  cargoHash = "sha256-5cDR4NJ/uBbwN/MD2MUthwKCVjGHZGp2y5D00Qf8xgc=";

  cargoBuildFlags = [
    "--bin=gdscript-formatter"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
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
