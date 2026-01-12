{
  lib,
  vscode-utils,
  claude-code,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "claude-code";
    publisher = "anthropic";
    version = "2.1.5";
    hash = "sha256-R7FRTvbadL12uSZjOHK2ggGlie6jDm+tV5Ei1LrVCZQ=";
  };

  postInstall = ''
    rm -f $out/share/vscode/extensions/anthropic.claude-code/resources/native-binary/claude
    ln -s ${claude-code}/bin/claude $out/share/vscode/extensions/anthropic.claude-code/resources/native-binary/claude
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
