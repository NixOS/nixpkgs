{
  lib,
  vscode-utils,
  vscode-extension-update-script,
  autoPatchelfHook,
  stdenv,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef =
    let
      sources = {
        "x86_64-linux" = {
          arch = "linux-x64";
          hash = "sha256-IoBA0fuy9XxZgswN1j9DfwDI218h2huapl1Bfs2AscI=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-EfoRRJFTNr+0JAkqWJ2pXwhBtmAXs9cANLzXb4obOMs=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-p2AjXFqoptxAwOdsievcjD/WLm0J03Rx/sT4ejUd6xM=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-C1nbQxL5YDWenLQ82tABuEWKWl/LoEizTWo/YnBQJFw=";
        };
      };
    in
    {
      publisher = "kilocode";
      name = "Kilo-Code";
      version = "7.2.0";
    }
    // sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system ${stdenv.hostPlatform.system}");

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = [ stdenv.cc.cc.lib ];

  passthru.updateScript = vscode-extension-update-script { };

  meta = {
    description = "Open Source AI coding assistant for planning, building, and fixing code";
    homepage = "https://kilo.ai";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=kilocode.Kilo-Code";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    platforms = [
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-linux"
      "x86_64-darwin"
    ];
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
  };
}
