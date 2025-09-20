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
          hash = "sha256-cuCxSODDNf2nhiUwgQT5SRugRLYOhq3igsvgP/hzcZE=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-OQqw/f2gSmFLN9CDn/auxXY6ao/XieAY7XVcI/kf1TA=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-qMWJS/4afJkSENk+BdaPPAynjEMErT2jjeFAkOSMfZ4=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-cj6cu/uSHflJHKub4LKaqPOMc7EC3Hlzxp7DfDpi9hU=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.16.4";
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
