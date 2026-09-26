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
        hash = "sha256-hcRjZ+z7gUg0jG12c9k98d+3knGgtW6XRF2tSfQQvOg=";
      };
      aarch64-linux = {
        arch = "linux-arm64";
        hash = "sha256-4375B2WsRajVtCewX2ruWDrdgsGlccefcfHDl8X6z9A=";
      };
      aarch64-darwin = {
        arch = "darwin-arm64";
        hash = "sha256-3na7btLQRIAb9EtHAHUSbLvdM/j/EJ9z0W5qv0Ysoz4=";
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
    version = "0.1.56";
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
    ];
    maintainers = [ ];
  };
})
