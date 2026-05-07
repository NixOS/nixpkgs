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
          hash = "sha256-xtbI0mqkjF21pL/0R0DReHVMlsf32ys2iprxp6AsTao=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-wpmx2RNAmGwwehBI/KpKNN3qxoWYFcESYKRRzc5pK/U=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-zp3V8o9BDV29PA8xSlZ/RglnYkuc1rd+N5CuXIqd4ME=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-7Scr8lumlZu5M1pGAWfQTMIpBXWU1/yp5kVE3LpFSVM=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.28.1";
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
