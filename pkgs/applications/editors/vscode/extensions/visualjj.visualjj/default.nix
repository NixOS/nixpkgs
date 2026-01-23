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
          hash = "sha256-NXlV80CV6EyALfJHT3x3pfjGiJfYxPT2JXTADMfB7yA=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-NWak0NXK5SxGm7JLpqR7zapEzxG+CDFdTcZDyCY6ifk=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-9lJfrqVFTROMqLaO9SUx9msACjHu0lTSKLRPPA8r8AM=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-iz3+iEXCYzItNTrAlzZAuM80U+TNlz/n1nljRvOfX3k=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.20.2";
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
