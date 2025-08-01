{
  lib,
  vscode-utils,
  plantuml,
  jq,
  moreutils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "plantuml";
    publisher = "jebbs";
    version = "2.18.1";
    hash = "sha256-o4FN/vUEK53ZLz5vAniUcnKDjWaKKH0oPZMbXVarDng=";
  };
  nativeBuildInputs = [
    jq
    moreutils
  ];
  postInstall = ''
    cd "$out/$installPrefix"
    jq '.contributes.configuration.properties."plantuml.java".default = "${plantuml}/bin/plantuml"' package.json | sponge package.json
  '';

  meta = {
    description = "Visual Studio Code extension for supporting Rich PlantUML";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=jebbs.plantuml";
    homepage = "https://github.com/qjebbs/vscode-plantuml";
    changelog = "https://marketplace.visualstudio.com/items/jebbs.plantuml/changelog";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
