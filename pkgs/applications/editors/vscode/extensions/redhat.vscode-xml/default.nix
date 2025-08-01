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
          hash = "sha256-FnMTpDXC/UIMPfcBbpZRo/T0LljFP0+syv2aTZjOczc=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-bPkRzOpd7nlIg3oLvrfIrcvrxJqnRhNZNzgao8ga+OM=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-UnRWxjmicfizn8SUspkhjjiYDJDFGI4ItIPLTnRZEy0=";
        };
      };
    in
    {
      publisher = "redhat";
      name = "vscode-xml";
      version = "0.29.0";
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
