{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gdscript-formatter";
<<<<<<< HEAD
  version = "0.18.1";
=======
  version = "0.18.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "GDQuest";
    repo = "GDScript-formatter";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-16ASwYNnAtOVB0xxomjyuopya5rtmZriOE4H4W1v6nE=";
=======
    hash = "sha256-DO8ctTmPUkB+XZ1iEkv3HLWprCH6IHdGXIWvn08PL+A=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    # Needed due to .gitattributes being used for the Godot addon and export-ignoring all files
    deepClone = true;
  };

<<<<<<< HEAD
  cargoHash = "sha256-HWPSZFe78+NjIV79Un2e06S4AKpw1xJbJuX0fh1YJdo=";
=======
  cargoHash = "sha256-b1seQakW2hZkclzkXX7DcTn+8TLinl2h0XMmdLHUT1A=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  cargoBuildFlags = [
    "--bin=gdscript-formatter"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
