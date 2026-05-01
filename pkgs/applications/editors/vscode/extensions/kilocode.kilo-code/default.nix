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
          hash = "sha256-YWutkvFv7+vkHbm6q+kS+WfHiAFJlIl/hfMXB1jx14A=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-zAo8jnbmf+SO/GdwHoLvThddnqHoQn0uUb6V93p4oaU=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-HgTewRD5e41G8pQJTw1jphemabKZj+82TM3YCRiQ7Do=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-gSphLx7kEyObvUNK66xdZREGw0pSVoEPOfJ6mORo3K8=";
        };
      };
    in
    {
      publisher = "kilocode";
      name = "Kilo-Code";
      version = "7.2.31";
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
