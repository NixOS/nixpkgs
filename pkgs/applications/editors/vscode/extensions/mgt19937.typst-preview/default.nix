# Keep pkgs/by-name/ty/typst-preview/package.nix in sync with this extension

{
  vscode-utils,
  lib,
  jq,
  moreutils,
  typst-preview,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "typst-preview";
    publisher = "mgt19937";
    version = "0.11.7";
    hash = "sha256-70dVGoSBDKCtvn7xiC/gAh4OQ8nNDiI/M900r2zlOfU=";
  };

  buildInputs = [ typst-preview ];

  nativeBuildInputs = [
    jq
    moreutils
  ];

  postInstall = ''
    cd "$out/$installPrefix"
    jq '.contributes.configuration.properties."typst-preview.executable".default = "${lib.getExe typst-preview}"' package.json | sponge package.json
  '';

  meta = {
    description = "Typst Preview is an extension for previewing your Typst files in vscode instantly";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=mgt19937.typst-preview";
    homepage = "https://github.com/Enter-tainer/typst-preview-vscode";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.drupol ];
  };
}
