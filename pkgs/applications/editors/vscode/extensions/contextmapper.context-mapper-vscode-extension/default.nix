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
    version = "6.12.0";
    hash = "sha256-iGaVipNvx6J3NgZ2KbBJOSVCwG+lr25u7mfMCY4yB18=";
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
