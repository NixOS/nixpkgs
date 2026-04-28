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
          hash = "sha256-J9QdRxN0NdCRfSUBUE7Ox2BG0vdnaWGq27jcR779qRw=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-53SJDBILWKVqz8EyXO/DF8+j+EK7iVJ47cjhlZhrIWw=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-/82zwt92T5JYGxhnvSmqTA/7ahut6P3SAU5POxUFowM=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-2ppC1sDDtDKAWpAW3RHGHeszhoKAVYnRoKw94ZOCaAs=";
        };
      };
    in
    {
      name = "claude-code";
      publisher = "anthropic";
      version = "2.1.121";
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
