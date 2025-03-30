{
  stdenvNoCC,
  lib,
  vscode-utils,
  vscode-extensions-update-script,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef =
    let
      sources = {
        "x86_64-linux" = {
          arch = "linux-x64";
          hash = "sha256-ub19F5vWUWg2eWUg/lst/+GrCsw6o6yeRQ9Lnb83Oow=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-sNxpfCZbT4rCBn7fYBimFiNsMg72i8GmLfK7EP+8hHg=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-snPaNPNTHFHZmaXckcjQuHTw/LvwaEj9irRLXnyrGHU=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-wcNms02vhe3WSWn0HE7owf/0W25EZvkLvRn2oQJewd4=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.13.6";
    }
    // sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system ${stdenvNoCC.hostPlatform.system}");

  passthru.updateScript = vscode-extensions-update-script { extraArgs = [ "--platforms" ]; };

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
