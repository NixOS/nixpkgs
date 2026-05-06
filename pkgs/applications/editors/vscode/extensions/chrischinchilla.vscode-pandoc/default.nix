{
  lib,
  vscode-utils,
  pandoc,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-pandoc";
    publisher = "chrischinchilla";
    version = "0.7.3";
    hash = "sha256-TGkNYA96mzFtUoM+XPKXJ/AM+hbiLc6Lvk5YDxFUwcI=";
  };
  executableConfig."pandoc.executable".package = pandoc;
  meta = {
    description = "Converts Markdown files to pdf, docx, or html files using pandoc";
    homepage = "https://github.com/ChrisChinchilla/vscode-pandoc#readme";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=yzane.markdown-pdf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
