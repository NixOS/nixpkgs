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
          hash = "sha256-YeF6LyQzVAXgZ5Iqr6YvNcACfiUukUsq7cybeCQdSYc=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-SjirNvI83eh3Gt5rGsaiLT6TJMH6LRQAasOFNy9OMCY=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-FjE3xTp5Mj1584bepVc4nZr3rxCR3CV+jplmA45VF44=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-SAf3+0QSFUDq09AZQnw78ps55RM/RwoAeQuVly7vn10=";
        };
      };
    in
    {
      publisher = "kilocode";
      name = "Kilo-Code";
      version = "7.2.20";
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
