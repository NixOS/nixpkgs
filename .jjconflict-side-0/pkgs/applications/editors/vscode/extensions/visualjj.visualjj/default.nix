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
          hash = "sha256-70IC1Df7FxIbh9iFPqC7ej+NpAW8BKD30qYlhtC0QLo=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-NA6QjtqtEWRHjs4s1F3tVnd+qwk3T7KAhZdNsCv2WXo=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-BIop7QBbJCRO5u81NMuRHcKtAHpPAWZFIApv7g/3pI8=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-mghcU1iyxlU1uY9tb4j5/qdy5TM+MFXN2ci95erzihg=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.14.5";
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
