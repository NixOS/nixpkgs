{
  jq,
  lib,
  moreutils,
  vscode-utils,
  eslint,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-eslint";
    publisher = "dbaeumer";
    version = "3.0.13";
    hash = "sha256-l5VvhQPxPaQsPhXUbFW2yGJjaqnNvijn4QkXPjf1WXo=";
  };

  nativeBuildInputs = [
    jq
    moreutils
  ];

  buildInputs = [ eslint ];

  postInstall = ''
    cd "$out/$installPrefix"
    jq '.contributes.configuration.properties."eslint.nodePath".default = "${eslint}/lib/node_modules"' package.json | sponge package.json
  '';

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/dbaeumer.vscode-eslint/changelog";
    description = "Integrates ESLint JavaScript into VS Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint";
    homepage = "https://github.com/Microsoft/vscode-eslint";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.datafoo ];
  };
}
