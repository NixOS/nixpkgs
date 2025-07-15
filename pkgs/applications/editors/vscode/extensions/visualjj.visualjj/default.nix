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
          hash = "sha256-3JEqkFY1vuI11HdM+X1rZkbVOrFpykAy7CdYxtyfu+0=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-yqb0PdhSpCecUxEO2ZUpFzn1wZcaDcfvFPXJW0gYgh4=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-CUpfezfvhVSROFBV8ZI9W+DpwxyH6QLvhOOO8O5PYag=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-AGc6wI15C7tZJAJ8yfx1xlQ8wQj/f8S3xHKwp+C/5x4=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.15.1";
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
