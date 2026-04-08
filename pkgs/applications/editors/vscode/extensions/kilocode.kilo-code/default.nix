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
          hash = "sha256-XeNdr1nWK4aYTBEgAu3hXotmrDJ31ocg+w4870TuEGA=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-yC8fBgj8lHR3y7OWUshWYNpn6fgp2SeKLv9WXxhVP0A=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-O/SoqC0pNnbNdXylAj0rlKyr7qaJNivw6xhecKFk7JU=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-pwdTllSB4IXDoyFuo2XxZjkS8lnIjp7AwgggBkjv3Y0=";
        };
      };
    in
    {
      publisher = "kilocode";
      name = "Kilo-Code";
      version = "7.1.22";
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
