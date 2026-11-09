{
  lib,
  vscode-utils,
}:
let
  version = "4.5.1";
in

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "pranaygp";
    name = "vscode-css-peek";
    inherit version;
    hash = "sha256-pgTkBfpkG7ggDJ7+d3tS9AlpqGcDDGSTei5P3VHraK8=";
  };

  meta = {
    description = "Allow peeking to css ID and class strings as definitions from html files to respective CSS";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=pranaygp.vscode-css-peek";
    homepage = "https://github.com/pranaygp/vscode-css-peek";
    changelog = "https://github.com/pranaygp/vscode-css-peek/blob/v${version}/README.md#changelog";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.kozm9000 ];
  };
}
