{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,

  # native check inputs
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "openscad-lsp";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "Leathong";
    repo = "openscad-LSP";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ACxsXGeVYmB13x/n+molCoScSOe6Zh2PYiaGGHnd4DQ=";
  };

  cargoHash = "sha256-Q4NrRVSic7M1CFq24ffUv3d835PmaHus4Z0lLnUQ7Ts=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "LSP (Language Server Protocol) server for OpenSCAD";
    mainProgram = "openscad-lsp";
    homepage = "https://github.com/Leathong/openscad-LSP";
    changelog = "https://github.com/Leathong/openscad-LSP/releases/tag/${finalAttrs.src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      c-h-johnson
      curious
    ];
  };
})
