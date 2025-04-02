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
          hash = "sha256-eeLALUmJoIJfLKbX7MWQFIexfid7eOPTK0UE1sgd5jA=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-DftuIxJpP3zcfsoCam4FoqO2PSS/xPTmdefjhWAJqc0=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-TiZTp19fcDYPvJnx7F/i96JD8gcE+t1irZstnuagchQ=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-oXKAxgZ1IH+qiw9E/96J7rmvSHgLPwLZItLpFRjh7c0=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.14.1";
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
