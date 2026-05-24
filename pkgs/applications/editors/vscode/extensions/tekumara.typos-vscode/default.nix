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
        hash = "sha256-jAQJh1JqomJDUFeb2N452ICo0azFelT8vHvEsBqXi8w=";
      };
      aarch64-linux = {
        arch = "linux-arm64";
        hash = "sha256-Z3cRojI4mCCS2t3aLojgImULQOobq5liDwoeHuzKEhY=";
      };
      x86_64-darwin = {
        arch = "darwin-x64";
        hash = "sha256-Th0cseTJk+CD3BO/99t0VMD7zcF6nxAfmHFhfN8j5sw=";
      };
      aarch64-darwin = {
        arch = "darwin-arm64";
        hash = "sha256-rHgMl71YCs9ea0nFnx+E2U8isL4zQzIvvE9tgxM7IiA=";
      };
    }
    .${system} or (throw "Unsupported system: ${system}");
in
vscode-utils.buildVscodeMarketplaceExtension (finalAttrs: {
  mktplcRef = {
    name = "typos-vscode";
    publisher = "tekumara";
    # Please update the corresponding binary (typos-lsp)
    # when updating this extension.
    # See pkgs/by-name/ty/typos-lsp/package.nix
    version = "0.1.51";
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
    changelog = "https://github.com/tekumara/typos-lsp/blob/v${finalAttrs.version}/CHANGELOG.md";
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
})
