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
          hash = "sha256-20YQYsNYvWDhFS8ZRtK9dtLtZ6wt1xGSsZjTNoXRr7g=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-+h+2JMl1UMUM1fcB8ddo7R2RuaQdjjWcd74APwWw/uc=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-rwk+bkHfCRtYEWpMi9/BABvT+LkpWi8ezAE4TK7ttkg=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-IbfqAZyAwS/01Mlniw+xOMktk4wQNXWTK5oyBX9g2sI=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.26.0";
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
