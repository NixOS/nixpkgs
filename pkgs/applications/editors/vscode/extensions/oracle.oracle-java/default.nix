{
  lib,
  vscode-utils,
  jdk24,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "oracle-java";
    publisher = "oracle";
    version = "24.0.0";
    hash = "sha256-sw+FJbpdkHABKgnRsA5tS6FYEjBD0/iVRCHHzf49Xx4=";
  };

  buildInputs = [
    jdk24
  ];

  meta = {
    description = "Java Platform Extension for Visual Studio Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=oracle.oracle-java";
    homepage = "https://github.com/oracle/javavscode/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.kiyotoko ];
  };
}
