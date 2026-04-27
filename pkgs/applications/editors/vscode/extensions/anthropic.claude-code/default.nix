{
  lib,
  stdenvNoCC,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef =
    let
      sources = {
        "x86_64-linux" = {
          arch = "linux-x64";
          hash = "sha256-w4kUYNnQW4KkIlzxnTASTBFxL3m3/NBwBET7/8ealIY=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-ZsVR7Qajv78A0+UfR+DqaUZyV1FFRjNs2+vJInboh6U=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-8zvhF5cs1XOGa/l2M27K2Mv2cgusNy51glFZf1OVdWI=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-Csb9F6HGWAgvPDjtsu35gjtGCuDLu0WQD1NNX/+S7F8=";
        };
      };
    in
    {
      name = "claude-code";
      publisher = "anthropic";
      version = "2.1.119";
    }
    // sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system ${stdenvNoCC.hostPlatform.system}");

  meta = {
    description = "Harness the power of Claude Code without leaving your IDE";
    homepage = "https://docs.anthropic.com/s/claude-code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
