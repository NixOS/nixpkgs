{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-remote-extensionpack";
    publisher = "ms-vscode-remote";
    version = "0.26.0";
    hash = "sha256-YUo0QbJILa9BzWub6Wi6cDD/Zsy/H8LZ8j+9H+5pVHY=";
  };

  meta = {
    description = "Visual Studio Code extension pack that lets you open any folder in a container, on a remote machine, or in WSL and take advantage of VS Code's full feature set";
    homepage = "https://github.com/Microsoft/vscode-remote-release";
    license = lib.licenses.unfree;
    maintainers = [ ];
  };
}
