{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "prettier-sql-vscode";
    publisher = "inferrinizzard";
    version = "1.6.0";
    hash = "sha256-l6pf/+uv8Bn4uDMX0CbzSjydTStr73uRY550Ad9wm7Q=";
  };

  meta = {
    description = "VSCode Extension to format SQL files";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=inferrinizzard.prettier-sql-vscode";
    homepage = "https://github.com/sql-formatter-org/sql-formatter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ AlexAntonik ];
  };
}
