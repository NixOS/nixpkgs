{
  lib,
  stdenvNoCC,
  vscode-utils,
  vscode-extension-update-script,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef =
    let
      sources = {
        "x86_64-linux" = {
          arch = "linux-x64";
          hash = "sha256-cP/oFn19CZ/G3kjdHNZGqXvoDE1qUtg6xrg/2MO14Lo=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-wtk8SasxXEQ3pCJpVTWR8wcY/bNaIZmImbAtrFWYWOo=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-XYdwVoDqK+88ZYUm6APyamFNx6XlYjy0R4CIhSMuRmU=";
        };
      };
    in
    {
      publisher = "redhat";
      name = "vscode-xml";
      version = "0.29.3";
    }
    // sources.${stdenvNoCC.hostPlatform.system} or { };

  passthru.updateScript = vscode-extension-update-script {
    extraArgs = [
      "--override-filename"
      "pkgs/applications/editors/vscode/extensions/redhat.vscode-xml/default.nix"
    ];
  };

  meta = {
    license = lib.licenses.epl20;
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  };
}
