{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dts-lsp";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "igor-prusov";
    repo = "dts-lsp";
    tag = finalAttrs.version;
    hash = "sha256-d2yiJ8vP3DuwnHGe4dq3B72XouW07We3zy4SSrKUoBo=";
  };

  cargoHash = "sha256-Sfr8BIrEQ6koYbjn5dW+pEdkVc6db/8aNJebUIcg3N4=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language Server for Device Tree Source files";
    homepage = "https://github.com/igor-prusov/dts-lsp";
    changelog = "https://github.com/igor-prusov/dts-lsp/blob/${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ lib.maintainers.jmbaur ];
    mainProgram = "dts-lsp";
  };
})
