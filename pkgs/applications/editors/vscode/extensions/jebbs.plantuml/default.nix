{
  lib,
  vscode-utils,
  plantuml,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "plantuml";
    publisher = "jebbs";
    version = "2.18.1";
    hash = "sha256-o4FN/vUEK53ZLz5vAniUcnKDjWaKKH0oPZMbXVarDng=";
  };
  executableConfig."plantuml.java".package = plantuml;
  meta = {
    description = "Visual Studio Code extension for supporting Rich PlantUML";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=jebbs.plantuml";
    homepage = "https://github.com/qjebbs/vscode-plantuml";
    changelog = "https://marketplace.visualstudio.com/items/jebbs.plantuml/changelog";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
