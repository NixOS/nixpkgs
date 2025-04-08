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
          hash = "sha256-Sno0UnWnuOogT9DMEF+8dMZLqxAoHSsKORkHpre40dE=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-GaqBiAs0G9h1p2itDITPFBkFD1uOmM0fEp4tKmYFCXY=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-uDRhsAGw7mEI2ztC8QWDtrHAeMwk9IzU5Sln7HQl+1Y=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-/5VEFXlGORo9t5ehDmLcqb0cYvJ6Gb1yIootyqpMZM8=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.14.4";
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
