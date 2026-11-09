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
          hash = "sha256-uOJ9PwRlibJdB+YP/9R2Gynlnb+NoFv/CfmB8/+eV7E=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-IZru/8URs6MwyUpUynOHbvfhlBvoY8V2oE+LVQmjQoc=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-UViU/VJzqQBmFquRo2iB1srSqUi8zxMfAYPxV7mC4yc=";
        };
      };
    in
    {
      publisher = "kilocode";
      name = "Kilo-Code";
      version = "7.8.27";
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
