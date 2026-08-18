{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "claude-dev";
    publisher = "saoudrizwan";
    version = "4.1.8";
    hash = "sha256-bhLnEsoifDQGHKCECTZ/BkAjuFQ9O9tODxzO2WMdybo=";
  };

  meta = {
    description = "Cline - autonomous coding agent VSCode extension, capable of creating/editing files, executing commands, using the browser, and more with your permission every step of the way";
    downloadPage = "https://github.com/cline/cline";
    homepage = "https://github.com/cline/cline";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.matteopacini ];
  };
}
