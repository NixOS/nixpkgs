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
          hash = "sha256-xsenzYvX6uAMK91K9fjhRAhYvxSobq4N1yBsksh4bkM=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-3f7Sw47uHigXD1sUE8LWfrfAmXCFRoSuYru106jv2Bk=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-pjqEVhqUsAPkfLOdIMoJooAabIfNG3vUSzMuNZtBS24=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-jPvkC5ZmA8LToXIZvkY1iMbEWnJGWQMT74RZ+PS3ZBg=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.27.1";
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
