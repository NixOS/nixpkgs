{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-wakatime";
    publisher = "WakaTime";
    version = "30.0.4";
    hash = "sha256-5y7LTkiR7dnSHbL80pqsTb57rnLyEbIrHT4xzseVj84=";
  };

  meta = {
    description = ''
      Visual Studio Code plugin for automatic time tracking and metrics generated
      from your programming activity
    '';
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ cizniarova ];
  };
}
