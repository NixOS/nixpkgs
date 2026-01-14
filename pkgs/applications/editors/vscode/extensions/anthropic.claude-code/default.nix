{
  lib,
  claude-code,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "claude-code";
    publisher = "anthropic";
    version = "2.1.7";
    hash = "sha256-Bj9VNhwgM0nO3b/Iptb70hkO2TjKxbEpxdYGyzFt3iA=";
  };

  postInstall = ''
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
