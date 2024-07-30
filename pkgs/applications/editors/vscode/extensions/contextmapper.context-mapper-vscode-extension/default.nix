{
  graphviz,
  jre,
  lib,
  makeWrapper,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension rec {
  mktplcRef = {
    name = "context-mapper-vscode-extension";
    publisher = "contextmapper";
    version = "6.11.0";
    hash = "sha256-TvApcBBI+Egu7t4tJuEYTs6mhvABOY2eXVb57O4gWfs=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ graphviz ];

  postInstall = ''
    wrapProgram $out/share/vscode/extensions/contextmapper.context-mapper-vscode-extension/lsp/bin/context-mapper-lsp \
      --set JAVA_HOME "${jre}"
  '';

  meta = {
    description = "VSCode extension for Context Mapper";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=${mktplcRef.publisher}.${mktplcRef.name}";
    homepage = "https://github.com/ContextMapper/vscode-extension";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.rhoriguchi ];
  };
}
