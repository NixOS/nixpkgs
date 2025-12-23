{
  lib,
  vscode-utils,
  jq,
  biome,
  moreutils,
  vscode-extension-update-script,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "biome";
    publisher = "biomejs";
    version = "2025.10.241456";
    hash = "sha256-tihEFcDDYr/khLIcJbR5VSC/RujEvp/gcnWlokAqNBc=";
  };

  postInstall = ''
    cd "$out/$installPrefix"
    ${lib.getExe jq} '.contributes.configuration.properties."biome.lsp.bin".oneOf[0].default = "${lib.getExe biome}"' package.json | ${lib.getExe' moreutils "sponge"} package.json
  '';

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
