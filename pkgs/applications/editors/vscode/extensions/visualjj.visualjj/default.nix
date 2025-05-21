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
          hash = "sha256-tnZh8WioZ4EtooQlM5RYQkvWO35PPeNTAyCbMQ4raXE=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-tkZRGO1W0QA/aEW2BqyPhmGt06yTvrsQ4Xp8jmbzPP0=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-hoZf3ofcPHkqyWwfL79Hnu5pzcLKRHD5PVOBjTXq828=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-qZnHSdcby7FNb1+EUB4O8dK30xtZWS4m07m8je0/CHI=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.15.0";
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
