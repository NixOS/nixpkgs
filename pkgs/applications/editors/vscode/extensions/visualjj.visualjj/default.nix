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
          hash = "sha256-4w/A3C9WWfKbZF3LnaLR9aZ78hvU+lrEXS8nnMbgzeA=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-+2+geG0UcCf7L+SbgKGjMkmctH+3q7nLsZFsb/BrhF0=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-QUopKDFQxWinvtkCkmRSCG2TpopGRRD8dXyfC3iww6Y=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-7ZglgfAbjdCS8R9MhX8qB7P4aCVDy76qFmQ7klzGbjg=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.27.0";
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
