{
  lib,
  vscode-utils,
  biome,
  vscode-extension-update-script,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "biome";
    publisher = "biomejs";
    version = "2026.8.190716";
    hash = "sha256-qd9/E1YkImondMzmRpjpO1uMvMAl30YFfi3rachDExs=";
  };

  executableConfig."biome.lsp.bin" = {
    extraJqExpr = ".oneOf[0]";
    package = biome;
  };

  passthru.updateScript = vscode-extension-update-script {
    extraArgs = [ "--pre-release" ];
  };

  meta = {
    changelog = "https://github.com/biomejs/biome-vscode/blob/main/CHANGELOG.md";
    description = "Biome LSP extension for Visual Studio Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=biomejs.biome";
    homepage = "https://github.com/biomejs/biome-vscode";
    license = with lib.licenses; [
      mit
      # or
      asl20
    ];
    maintainers = [ ];
  };
}
