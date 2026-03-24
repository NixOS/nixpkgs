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
          hash = "sha256-tG2PUESSzOs5jEPD7Wgtee832pOTOLkxxV/FP7Md6k8=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-CqgMcb03eA+orz0rmKoSi5qtQXAN/MzrmogGQGV2yzw=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-kDv8t9COz8sWRH9FlrhrDC9UqGBXD7F0IMaWCbZYwBk=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-S27qkOYs3arqa68raX+0itOywnlQZAIjxD93GCEjKhs=";
        };
      };
    in
    {
      publisher = "kilocode";
      name = "Kilo-Code";
      version = "7.0.51";
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
