{
  lib,
  vscode-utils,
  ungoogled-chromium,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "markdown-pdf";
    publisher = "yzane";
    version = "2.2.0";
    hash = "sha256-rhOSb2wmVdSEFErsgze/+EvKHhgBGRlt2L9AccxWCkE=";
  };
  executableConfig."markdown-pdf.executablePath".package = ungoogled-chromium;
  meta = {
    description = "Converts Markdown files to pdf, html, png or jpeg files";
    homepage = "https://github.com/yzane/vscode-markdown-pdf#readme";
    changelog = "https://github.com/yzane/vscode-markdown-pdf/blob/master/CHANGELOG.md";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=yzane.markdown-pdf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
