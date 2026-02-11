{
  lib,
  claude-code,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "claude-code";
    publisher = "anthropic";
    version = "2.1.37";
    hash = "sha256-Lc3TNj74BW/M1sK+bz/xw4L5B6KKBUh2uzXckScwPr8=";
  };

  postInstall = ''
    mkdir -p "$out/$installPrefix/resources/native-binary"
    rm -f "$out/$installPrefix/resources/native-binary/claude"*
    ln -s "${claude-code}/bin/claude" "$out/$installPrefix/resources/native-binary/claude"
  '';

  meta = {
    description = "Harness the power of Claude Code without leaving your IDE";
    homepage = "https://docs.anthropic.com/s/claude-code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
  };
}
