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
        hash = "sha256-fn9cVi5fa+wv2LitNi4Bb4oFIDKFdl1mTrNPlK3Z0XE=";
      };
      aarch64-linux = {
        arch = "linux-arm64";
        hash = "sha256-B+oKdmNBZAydWfwZHdgVMc1eemrrrANnQyhIphKcDxg=";
      };
      x86_64-darwin = {
        arch = "darwin-x64";
        hash = "sha256-sJ4ZfdMytAOehcBQANl5X3Q2snbjd9/t7uUIb9QRMGw=";
      };
      aarch64-darwin = {
        arch = "darwin-arm64";
        hash = "sha256-xCs61aCeIUlICyVCu5sKoVakpVPr01FBxIlmA3SZnt0=";
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
    version = "0.1.36";
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
    maintainers = [ lib.maintainers.drupol ];
  };
}
