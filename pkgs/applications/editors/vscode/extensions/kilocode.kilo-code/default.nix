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
          hash = "sha256-uPmJyEq7X6uJzE1M5Xywax1mrnTcg6jOb9MlpKZ0WRk=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-oEVt3VbRUPD4tfQs0EU7RX6671fCJiMi38wF+76RzZI=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-b46f0f99rjBivewC9jUbAFiKK+DS1XKv+AynUlKHliw=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-yBJjt53eOazV9FB8qimerwXTX4vCIPC+lyXtau/3FyI=";
        };
      };
    in
    {
      publisher = "kilocode";
      name = "Kilo-Code";
      version = "7.3.53";
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
