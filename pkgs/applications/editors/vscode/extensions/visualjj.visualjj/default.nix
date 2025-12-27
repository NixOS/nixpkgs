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
          hash = "sha256-0pauLEzWrKkiFy6nFp734sAxr5skkXNNojUiEL0WdEM=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-UDbXhMzl5DjkuMSqCv9R0GI+qBqV0xccrmFm8vYCrIQ=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-GuEZXUaFasjz4L6ylc2mcoWnn9d0I49Q0Sxmik3kwt0=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-FcPjj80FC7PoO/bVlLu7fk/HGyXfdkGyPEhlM2LU7/w=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.22.0";
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
