{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "claude-dev";
    publisher = "saoudrizwan";
    version = "3.0.12";
    hash = "sha256-GlBo4MIoIazKEYHv4yXpRGLVElOnjYgD9gB6rMQxeGg=";
  };

  meta = {
    description = "A VSCode extension providing an autonomous coding agent right in your IDE, capable of creating/editing files, executing commands, using the browser, and more with your permission every step of the way";
    downloadPage = "https://github.com/cline/cline";
    homepage = "https://github.com/cline/cline";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.drupol ];
  };
}
