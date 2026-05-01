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
          hash = "sha256-P5LEN+wTfJ9p0vG4z/FAB4u2hFLcqy7Xc18qC4W5x8U=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-cNiXCrOw3ET/BTfMxYfr01F+5lTXbKH3vKpRQQdnRLc=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-zCGwaw5Dgd0o5t+h0sjPZ1nDp/JqC2Wx4QfQYv3jg4w=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-M5BQdlEe5eN91Mz8trMFbFNeRoMIpGSOHpBSGQQVJc0=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.20.0";
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
