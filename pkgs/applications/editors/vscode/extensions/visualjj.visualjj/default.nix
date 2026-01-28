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
          hash = "sha256-yPDT9ph2bndjFU9ytIWJOzbBORx9L7UcMyhFRZAOEeA=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-AMr/2RA0CrmWnDK9MZhMe5I9gkRkQ5iQnchBF7/2BlA=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-wCKLBVqXJsr7NwUtgMTx7waQvsUwktmugtuaFb4Avr0=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-Y7273Oh/C+oylgMz3aJXDuuI+iQZMkYCTEBTMikFp0c=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.22.4";
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
