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
          hash = "sha256-vm12qVJ6+KbyHdzB/Q4SrEZDUKVsKJufjbVn9OBGbns=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-1dunJX+7oL2RqsK2pCScKAe/O0b3ypfgsuHXoDvvChM=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-5IG0H3QIY6ll77aZ6/8uFeIpgjupjBx0GfFJaX7Wep4=";
        };
      };
    in
    {
      publisher = "redhat";
      name = "vscode-xml";
      version = "0.29.2";
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
