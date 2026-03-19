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
          hash = "sha256-fZFWZiPuKtHWmzqJX/Mtb37lKTnU/TRISbS1qewcZzs=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-ZePZFmz3S6DCuIPqaL4xaLaWypNxre9xe7tRfk8JdQM=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-2gYrpUtzP1XTtkgEypoZLfMwDzBGMriqD935D1r1Onc=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-skvZ2wtYlXAYRscbUti6uBEEyM9ocJ9D/EuTMPQXB0Y=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.24.3";
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
