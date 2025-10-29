{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension rec {
  mktplcRef = {
    name = "oracle-java";
    publisher = "oracle";
    version = "24.1.2";
    hash = "sha256-sw+FJbpdkHABKgnRsA5tS6FYEjBD0/iVRCHHzf49Xx4=";
  };

  meta = {
    changelog = "https://github.com/oracle/javavscode/releases/tag/v${mktplcRef.version}";
    description = "Java Platform Extension for Visual Studio Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=oracle.oracle-java";
    homepage = "https://github.com/oracle/javavscode/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.kiyotoko ];
  };
}
