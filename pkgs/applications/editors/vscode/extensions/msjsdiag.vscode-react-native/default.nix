{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "msjsdiag";
    name = "vscode-react-native";
    version = "1.13.0";
    hash = "sha256-zryzoO9sb1+Kszwup5EhnN/YDmAPz7TOQW9I/K28Fmg=";
  };

  meta = {
    changelog = "https://github.com/microsoft/vscode-react-native/releases";
    description = "Development environment for React Native projects for Visual Studio Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=msjsdiag.vscode-react-native";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.guhou ];
  };
}
