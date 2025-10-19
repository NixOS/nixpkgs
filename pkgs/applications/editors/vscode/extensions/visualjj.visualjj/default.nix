{
  stdenvNoCC,
  lib,
  vscode-utils,
  vscode-extension-update-script,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef =
    let
      sources = {
        "x86_64-linux" = {
          arch = "linux-x64";
          hash = "sha256-WhCUOHS2y1NNTEs3Oo6lHz1YcQmj/9zcLFNi7dIO2Hs=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-M3ZC9lq0hVoBaxzaOuzeKRy7iAPsPgi+2IHU0KaujmI=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-ElqAiZGulYiSVay74UC04C0lKSHo1AwhtE05To8ir84=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-x7sZdxjouRBuCz5po+54HJ5Cdc9oEk5REplfQmNdvB4=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.18.0";
    }
    // sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system ${stdenvNoCC.hostPlatform.system}");

  passthru.updateScript = vscode-extension-update-script { };

  meta = {
    description = "Jujutsu version control integration, for simpler Git workflow";
    downloadPage = "https://www.visualjj.com";
    homepage = "https://www.visualjj.com";
    license = lib.licenses.unfree;
    platforms = [
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-linux"
      "x86_64-darwin"
    ];
    maintainers = [ ];
  };
}
