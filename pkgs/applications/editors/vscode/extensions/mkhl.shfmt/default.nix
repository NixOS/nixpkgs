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
    version = "1.4.0";
    hash = "sha256-5qi2BRwftuW9Isveb7vRwPPPu2w7LTfhNO0xHFNruGI=";
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
