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
          hash = "sha256-s3peDZApzSfemXRqRjf5fYQGHVf1DAP7XG4NuOqiGcY=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-WutwGOcXoREk6oUdFjhsKcrf64CG4GSn9JgGWiQe9l8=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-377T8cfY4jHX+iJjdDScMP+wX6UZCYLasl16ngwfq6U=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-fufJ9NV73skhwBFe2vCLjh5ykQagXfO0VAdHGPhfOQ4=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.14.2";
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
