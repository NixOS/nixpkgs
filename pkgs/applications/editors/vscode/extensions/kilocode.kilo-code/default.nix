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
          hash = "sha256-InMpjiWne/1R0wK3Yp/chABrVF7zoQBVwCg5zvAnlwM=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-Y6Z/MWQKbmtAuFo5g8m5+qEOivgNR+EIso2LnGJ+5pw=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-SYqn8YqAPD6dlj4Bi8q9Rlmj9Ziqoyog/vV8Li8fPhk=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-5aekArgpiB8aMIg8OtBgLcQlL04DD/78ElybKd1i6SI=";
        };
      };
    in
    {
      publisher = "kilocode";
      name = "Kilo-Code";
      version = "7.3.54";
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
