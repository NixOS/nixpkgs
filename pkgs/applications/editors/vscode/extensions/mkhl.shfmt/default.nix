{
  lib,
  vscode-utils,
  jq,
  shfmt,
  moreutils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "shfmt";
    publisher = "mkhl";
    version = "1.5.2";
    hash = "sha256-Mff3ZpxnLp/cEB17T0KGZ4GWG8jN4VxrfR/wIEi2ouM=";
  };

  postInstall = ''
    cd "$out/$installPrefix"
    ${lib.getExe jq} '.contributes.configuration.properties."shfmt.executablePath".default = "${lib.getExe shfmt}"' package.json | ${lib.getExe' moreutils "sponge"} package.json
  '';

  meta = {
    description = "Extension uses shfmt to provide a formatter for shell script documents";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=mkhl.shfmt";
    homepage = "https://codeberg.org/mkhl/vscode-shfmt";
    license = lib.licenses.bsd0;
    maintainers = [ lib.maintainers.therobot2105 ];
  };
}
