{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "claude-dev";
    publisher = "saoudrizwan";
    version = "4.1.16";
    hash = "sha256-ZsKIpyn2ZZzrfxAR8HAjNFMVQ5UdnH7bYaO7AdUCTKc=";
  };

  meta = {
    description = "Cline - autonomous coding agent VSCode extension, capable of creating/editing files, executing commands, using the browser, and more with your permission every step of the way";
    downloadPage = "https://github.com/cline/cline";
    homepage = "https://github.com/cline/cline";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.matteopacini ];
  };
}
