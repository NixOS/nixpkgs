{
  lib,
  vscode-utils,
  jq,
  python3,
  moreutils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "oliver-ni";
    name = "scheme-fmt";
    version = "1.2.1";
    hash = "sha256-oTXy0Vjd0s7ZYZzr36ILQOJm4BW9Qd7y8fGbnhkaD1Y=";
  };

  postInstall = ''
    cd "$out/$installPrefix"
    ${lib.getExe jq} '.contributes.configuration.properties."scheme-fmt.pythonPath".default = "${lib.getExe python3}"' package.json | ${lib.getExe' moreutils "sponge"} package.json
  '';

  meta = {
    description = "Formats Scheme source code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=oliver-ni.scheme-fmt";
    homepage = "https://github.com/oliver-ni/scheme-fmt";
    license = lib.licenses.cc0;
  };
}
