{ lib, vscode-utils, plantuml, jq, moreutils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "plantuml";
    publisher = "jebbs";
    version = "2.17.4";
    sha256 = "sha256-fnz6ubB73i7rJcv+paYyNV1r4cReuyFPjgPM0HO40ug=";
  };
  nativeBuildInputs = [ jq moreutils ];
  postInstall = ''
    cd "$out/$installPrefix"
    jq '.contributes.configuration.properties."plantuml.java".default = "${plantuml}/bin/plantuml"' package.json | sponge package.json
  '';

  meta = {
    description = "A Visual Studio Code extension for supporting Rich PlantUML";
    downloadPage =
      "https://marketplace.visualstudio.com/items?itemName=jebbs.plantuml";
    homepage = "https://github.com/qjebbs/vscode-plantuml";
    changelog =
      "https://marketplace.visualstudio.com/items/jebbs.plantuml/changelog";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.victormignot ];
  };
}

