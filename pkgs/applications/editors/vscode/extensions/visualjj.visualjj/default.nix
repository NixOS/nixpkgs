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
          hash = "sha256-qyhYpEkkXjG48JXSxOodgvh18R/nOOcP2m3m0OpdqvY=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-elhKqa9aLcx+3CTYt1S1BiE+Y5ldLc5ilfnfPoEEd3w=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-r2DmSo1TLyZSFKVsbvYhF1CkNODgjotNFXhA+q69MAw=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-4qGX4TwT9gtJbZt7JLbnQwGLA13yoqZQsydtfr4Kivw=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.24.1";
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
