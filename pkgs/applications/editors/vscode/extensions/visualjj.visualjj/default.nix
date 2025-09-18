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
          hash = "sha256-EfUwtKKyoX1/JNoVe3YsfxoLmjHWkLgFHKQqwDMjGMs=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-fZRQIFwDsUsIw9YwsjMhMPeMTOe/JATDBq66yKfJQRU=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-ig80H563Mv0Xs4Jh9Ni8Hn9vXAFYwycqNvSO3JJ3t+8=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-9D1H/u8YvgCvVcvm/Cy8GqQrutkSj6E7aqZdyX96LDw=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.16.2";
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
