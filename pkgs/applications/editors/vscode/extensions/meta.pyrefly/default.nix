{
  stdenvNoCC,
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef =
    let
      sources = {
        "x86_64-linux" = {
          arch = "linux-x64";
          hash = "sha256-tSAlLJ7CoJIzAXdeqU6ZTo7UglZpCtgvUeGgRwq+EaE=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-En+Uxv+pgKLX7XmQCAWWNqSoBbcAkcITLikhKYy7eV4=";
        };
      };
    in
    {
      publisher = "meta";
      name = "pyrefly";
      version = "1.3.1";
    }
    // sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system ${stdenvNoCC.hostPlatform.system}");

  meta = {
    description = "Visual Studio Code extension for Pyrefly Python language tooling";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=meta.pyrefly";
    homepage = "https://github.com/facebook/pyrefly";
    license = lib.licenses.mit;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
