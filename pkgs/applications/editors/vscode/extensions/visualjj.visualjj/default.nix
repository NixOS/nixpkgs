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
          hash = "sha256-rEy5DXXBgyY2/vb4jm3VLbHiBEiUpvFWPjgACBS/Iec=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-lBOu0acFAfOUiBcm7+UYN1XMNWOW73kj+HpVGRVQrPE=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-Z1Ml70Ylepgw00aAzmhp21P047ZsKXCmX0DfgjvZhdY=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-oMK2t2rFYCPS8sVKaNOIcFFMsmXrCNddxVaydftrrtc=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.14.7";
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
