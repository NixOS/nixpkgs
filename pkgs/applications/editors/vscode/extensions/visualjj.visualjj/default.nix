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
          hash = "sha256-/6V4hjwp3Vy4WEwTtcYvJk6Rt3AIeKqXWJ09Zsp9CZg=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-bMwiMIhsvF6Q12vCgt9Os109acqW8Ovpt3o9Y8Sf+gk=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-SwBHNKqif3mGqNSF6Y100HCDaLmARe0jApPol7AzsOQ=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-SGTQdjvrXkEaCuHv9dfJfCBUgkfOtf+kLPiHYAqJ7+8=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.15.4";
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
    maintainers = [ lib.maintainers.drupol ];
  };
}
