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
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "Leathong";
    repo = "openscad-LSP";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vzlwt1lTaZIqHS/+6bVPHjd+Ex3G/YDVNW0JKZ0arnk=";
  };

  cargoHash = "sha256-BU3gabsC/5lH59NSSBn2Zr5/egxcHAt7iCAftrOh1ak=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "LSP (Language Server Protocol) server for OpenSCAD";
    mainProgram = "openscad-lsp";
    homepage = "https://github.com/Leathong/openscad-LSP";
    changelog = "https://github.com/Leathong/openscad-LSP/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      c-h-johnson
      curious
    ];
  };
})
