{
  lib,
  vscode-utils,
  jq,
  moreutils,
  ungoogled-chromium,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "markdown-pdf";
    publisher = "yzane";
    version = "1.5.0";
    hash = "sha256-aiifZgHXC4GUEbkKAbLc0p/jUZxp1jF/J1Y/KIyvLIE=";
  };
  nativeBuildInputs = [
    jq
    moreutils
  ];
  postInstall = ''
    jq '.contributes.configuration.properties."markdown-pdf.executablePath".default = "${lib.getExe ungoogled-chromium}"' $out/$installPrefix/package.json | sponge $out/$installPrefix/package.json
  '';
  meta = {
    description = "Converts Markdown files to pdf, html, png or jpeg files";
    homepage = "https://github.com/yzane/vscode-markdown-pdf#readme";
    changelog = "https://github.com/yzane/vscode-markdown-pdf/blob/master/CHANGELOG.md";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=yzane.markdown-pdf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
