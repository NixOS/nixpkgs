{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension rec {
  mktplcRef = {
    name = "oracle-java";
    publisher = "oracle";
    version = "27.0.0";
    hash = "sha256-yXe07ZspiIN336DTqgzu8TbY5TC8vZ4XFIW4kr/WU0E=";
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
