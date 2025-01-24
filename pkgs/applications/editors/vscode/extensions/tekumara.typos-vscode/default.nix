{
  stdenv,
  jq,
  lib,
  moreutils,
  typos-lsp,
  vscode-utils,
}:
let
  inherit (stdenv.hostPlatform) system;

  extInfo =
    {
      x86_64-linux = {
        arch = "linux-x64";
        hash = "sha256-NdVSQQ5OeBPGSLbynUArNbfm+a2HCc/gwJMKfEDgzDM=";
      };
      aarch64-linux = {
        arch = "linux-arm64";
        hash = "sha256-4FjA3mUz+DVBiMUJAlGkUbpDtZuDYuUHPWA4QUiqd5w=";
      };
      x86_64-darwin = {
        arch = "darwin-x64";
        hash = "sha256-aexe9hrUxb3ZnrgJrvEXu2PZPmxOGdkk9exrfDaXA7s=";
      };
      aarch64-darwin = {
        arch = "darwin-arm64";
        hash = "sha256-ijmKU+eU3R3mxeFxFr5AtVwGYVBuYWecD8W+0gHzP5w=";
      };
    }
    .${system} or (throw "Unsupported system: ${system}");
in
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "typos-vscode";
    publisher = "tekumara";
    # Please update the corresponding binary (typos-lsp)
    # when updating this extension.
    # See pkgs/by-name/ty/typos-lsp/package.nix
    version = "0.1.26";
    inherit (extInfo) hash arch;
  };

  nativeBuildInputs = [
    jq
    moreutils
  ];

  buildInputs = [ typos-lsp ];

  postInstall = ''
    cd "$out/$installPrefix"
    jq '.contributes.configuration.properties."typos.path".default = "${lib.getExe typos-lsp}"' package.json | sponge package.json
  '';

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/tekumara.typos-vscode/changelog";
    description = "VSCode extension for providing a low false-positive source code spell checker";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=tekumara.typos-vscode";
    homepage = "https://github.com/tekumara/typos-lsp";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.drupol ];
  };
}
