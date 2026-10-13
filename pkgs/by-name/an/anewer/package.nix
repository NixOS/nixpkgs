{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "anewer";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "ysf";
    repo = "anewer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h18La0Xu0SX4yR3TkNCttxNOTLli3tLTifvvL6EpPnM=";
  };

  cargoHash = "sha256-c2AztEVbmY8AzdDHEqZcFLu3OaN2UtSXWU8fd+11doU=";

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Append lines from stdin to a file if they don't already exist in the file";
    mainProgram = "anewer";
    homepage = "https://github.com/ysf/anewer";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ tomasrivera ];
  };
})
