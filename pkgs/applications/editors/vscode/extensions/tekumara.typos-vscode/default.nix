{
  stdenv,
  jq,
  lib,
  moreutils,
  typos-lsp,
  vscode-utils,
  vscode-extension-update-script,
}:
let
  inherit (stdenv.hostPlatform) system;

  extInfo =
    {
      x86_64-linux = {
        arch = "linux-x64";
        hash = "sha256-DeyQgxfPD7R2OjQZ99PNN7hV0Vt9jk5sw+XcM+yIURI=";
      };
      aarch64-linux = {
        arch = "linux-arm64";
        hash = "sha256-A8xjglh1re02mix5BpE00FNyU6Cjj01vz48lmz2acG8=";
      };
      x86_64-darwin = {
        arch = "darwin-x64";
        hash = "sha256-mK/pLDemgmVuLAMYMEeSvi96ckHNq8ie2Y+JENtaTXA=";
      };
      aarch64-darwin = {
        arch = "darwin-arm64";
        hash = "sha256-taFeZB00iBoYQULhlRHDjrj/Zm7aXYgbPiPK7xjnsYU=";
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
    version = "0.1.45";
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

  passthru.updateScript = vscode-extension-update-script { };

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/tekumara.typos-vscode/changelog";
    description = "VSCode extension for providing a low false-positive source code spell checker";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=tekumara.typos-vscode";
    homepage = "https://github.com/tekumara/typos-lsp";
    license = lib.licenses.mit;
    platforms = [
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-linux"
      "x86_64-darwin"
    ];
    maintainers = [ ];
  };
}
