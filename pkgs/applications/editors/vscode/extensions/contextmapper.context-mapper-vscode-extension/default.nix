{ graphviz
, jre
, lib
, makeWrapper
, vscode-utils
}:

vscode-utils.buildVscodeMarketplaceExtension rec {
  mktplcRef = {
    name = "context-mapper-vscode-extension";
    publisher = "contextmapper";
    version = "6.7.0";
    sha256 = "sha256-vlDVqn1Je0eo5Nf2gyotSvhIa07tWCINe79RZSyMzcA=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    graphviz
  ];

  postInstall = ''
    wrapProgram $out/share/vscode/extensions/contextmapper.context-mapper-vscode-extension/lsp/bin/context-mapper-lsp \
      --set JAVA_HOME "${jre}"
  '';

  meta = {
    description = "A VSCode extension for Context Mapper";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=${mktplcRef.publisher}.${mktplcRef.name}";
    homepage = "https://github.com/ContextMapper/vscode-extension";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.rhoriguchi ];
  };
}
