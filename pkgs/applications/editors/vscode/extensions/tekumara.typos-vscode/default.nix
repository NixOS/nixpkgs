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
        hash = "sha256-CPUlJ1QzGiZKd4r46Iioc5svw0oLsMsYnc0KxT1p0zM=";
      };
      aarch64-linux = {
        arch = "linux-arm64";
        hash = "sha256-qSTCZHL7nfB300qwuqgl/4u+SYNMA2BFCrD+yQEgN/c=";
      };
      x86_64-darwin = {
        arch = "darwin-x64";
        hash = "sha256-FcZH2bB5B3wnu6F76kGp9FBdD3yZtr57TQ5xaUfRcmY=";
      };
      aarch64-darwin = {
        arch = "darwin-arm64";
        hash = "sha256-3HdK4x2WNdb9Zxqjtn9lmbgrMOzz14rH0ZF0x9B0BHY=";
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
    version = "0.1.18";
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
