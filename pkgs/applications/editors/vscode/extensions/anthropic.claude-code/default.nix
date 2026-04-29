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
          hash = "sha256-cDR/E5ATkKHUhvfQ+721M1DbNNxbSzWdnah7kEpyIxc=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-8vJHvwYdCdQb0kHNbM6KNp27BJh8RGrBmw++Zz7nLf4=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-y93nqrqeLrOSPu+/NsKVg1yYPGT1x5XENO3VE/+uQU4=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-CYewM/KAk/WrEBiDK/aCkNc4/sGMIDnrHAoHIYU/h+o=";
        };
      };
    in
    {
      name = "claude-code";
      publisher = "anthropic";
      version = "2.1.123";
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
