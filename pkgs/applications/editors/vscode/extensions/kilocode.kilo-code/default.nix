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
          hash = "sha256-8NnxaIdavd81xz4JDfzs2kwY2PkLxpgU3zoF1xQOefA=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-8HwQmCFBJwiF++FJpA6MfCuwaTHLCPFDjR2bUdaRYK0=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-H+nCm8dkXR4V1JdMOeKL6nCAb45o29yZc7S87Ui7Cz0=";
        };
      };
    in
    {
      publisher = "kilocode";
      name = "Kilo-Code";
      version = "7.8.12";
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
    ];
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
  };
}
