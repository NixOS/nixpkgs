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
          hash = "sha256-HbaB0WnWNOxooZDuAFbpCZi3EDrqUzDAEPovfN670hk=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-K+I36W1y31WG9JNd25L4AbxsIqS6zWrrgQVUAd+BEqY=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-AMTgCdUwe0ba6tuWj+GEtkcV/x0TCjXNVlrujoQ+Pe4=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-x0zki117HMP9M3pNeN4FVIzyIcTJIe3MO0GFsK0J8BY=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.16.6";
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
