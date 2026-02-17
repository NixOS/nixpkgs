{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdwatch";
  version = "0.1.17";

  src = fetchFromGitHub {
    owner = "santoshxshrestha";
    repo = "mdwatch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y0biB09WQPgnNhxUmLpGNbCuuNjgjnB4vwsJrSWn+Lo=";
  };

  cargoHash = "sha256-bc1hbTzGSun5nXonMJHA6LFPcl1fFR1nUx9+GCjQ5UY=";

  updateScript = nix-update-script { };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Simple CLI tool to live-preview Markdown files in your browser";
    homepage = "https://github.com/santoshxshrestha/mdwatch";
    changelog = "https://github.com/santoshxshrestha/mdwatch/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ x123 ];
    mainProgram = "mdwatch";
  };
})
