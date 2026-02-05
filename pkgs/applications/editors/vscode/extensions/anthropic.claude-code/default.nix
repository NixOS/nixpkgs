{
  lib,
  claude-code,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "claude-code";
    publisher = "anthropic";
    version = "2.1.32";
    hash = "sha256-bbhx7P0TmvTLf7+M+mhTErq95qS5WedU8b6GaxV3vrM=";
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
