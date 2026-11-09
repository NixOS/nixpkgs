{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gdscript-formatter";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "GDQuest";
    repo = "GDScript-formatter";
    tag = finalAttrs.version;
    hash = "sha256-F6sMTR49J1id4E480lxxOvkRmhQ134ZIj7M1pXUpXVg=";
    # Needed due to .gitattributes being used for the Godot addon and export-ignoring all files
    deepClone = true;
    # Avoid hash differences due to differences in .git
    leaveDotGit = false;
  };

  cargoHash = "sha256-Ry94Mp60iJPmEBtlJgASfE0VgyHEpG2OTERb1b9iEPU=";

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
