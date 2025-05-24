{
  jq,
  lib,
  moreutils,
  vscode-utils,
  nodePackages,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "prettier-vscode";
    publisher = "esbenp";
    version = "11.0.0";
    hash = "sha256-pNjkJhof19cuK0PsXJ/Q/Zb2H7eoIkfXJMLZJ4lDn7k=";
  };

  nativeBuildInputs = [
    jq
    moreutils
  ];

  buildInputs = [ nodePackages.prettier ];

  postInstall = ''
    cd "$out/$installPrefix"
    jq '.contributes.configuration.properties."prettier.prettierPath".default = "${nodePackages.prettier}/lib/node_modules/prettier"' package.json | sponge package.json
  '';

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/esbenp.prettier-vscode/changelog";
    description = "Code formatter using prettier";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode";
    homepage = "https://github.com/prettier/prettier-vscode";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.datafoo ];
  };
}
