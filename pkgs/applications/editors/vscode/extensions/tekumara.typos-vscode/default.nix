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
        hash = "sha256-fvDzsFOG1pdmpC3RDY8zGP0yL/TzX6i00LnIX+yceVU=";
      };
      aarch64-linux = {
        arch = "linux-arm64";
        hash = "sha256-3yRZzOTuiTbkUUz1D3mZo7G5vayM6W9YBbJxTiVou9g=";
      };
      x86_64-darwin = {
        arch = "darwin-x64";
        hash = "sha256-fKvR2bea4UxvnZ+LlWR/ahpKe8mk5f4mZrjqTFpsC5A=";
      };
      aarch64-darwin = {
        arch = "darwin-arm64";
        hash = "sha256-nkK3BH+MRi6KdThq4kYR9ZAfnuSkC2r/lKWpEtmD7Ak=";
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
    version = "0.1.19";
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
