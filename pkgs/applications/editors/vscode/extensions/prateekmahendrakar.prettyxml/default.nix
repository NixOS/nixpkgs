{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "prettyxml";
    publisher = "prateekmahendrakar";
    version = "6.8.0";
    hash = "sha256-QfFrWxuHPVmIHgTEdiWPG7J5j3G/Fw1mvV8RY27VpQk=";
  };
  meta = {
    description = "Formats XML documents just like Visual Studio.";
    homepage = "https://github.com/pmahend1/prettyxml#readme";
    changelog = "https://github.com/pmahend1/prettyxml/blob/master/CHANGELOG.md";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=prateekmahendrakar.prettyxml";
    license = lib.licenses.mit;
  };
}
