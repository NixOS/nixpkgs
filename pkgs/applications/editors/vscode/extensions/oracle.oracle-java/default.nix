{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension rec {
  mktplcRef = {
    name = "oracle-java";
    publisher = "oracle";
    version = "25.0.0";
    hash = "sha256-e0DO+42+3CyMP3+25gj0kLDFK53vkv4UqD2pQhXmqng=";
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
