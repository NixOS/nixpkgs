{
  lib,
  vscode-utils,
  ungoogled-chromium,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "markdown-pdf";
    publisher = "yzane";
    version = "2.0.1";
    hash = "sha256-XykOUbCiTVtfmp5H9UC4gFPBxmrIJR7jv9VvLljOSM0=";
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
