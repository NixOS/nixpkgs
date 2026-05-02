{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "claude-dev";
    publisher = "saoudrizwan";
    version = "3.81.0";
    hash = "sha256-gVQmKuyUH+bXpr7X2Z23U2oKFnAV2mxhckjef2uL8KQ=";
  };

  meta = {
    description = "Cline - autonomous coding agent VSCode extension, capable of creating/editing files, executing commands, using the browser, and more with your permission every step of the way";
    downloadPage = "https://github.com/cline/cline";
    homepage = "https://github.com/cline/cline";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.matteopacini ];
  };
}
