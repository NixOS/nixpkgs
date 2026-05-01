{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension rec {
  mktplcRef = {
    name = "oracle-java";
    publisher = "oracle";
    version = "24.1.2";
    hash = "sha256-RX+Yq7fVmN797qlvSWV9hOqQV3lpWBzDjOMm/1sbv0k=";
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
