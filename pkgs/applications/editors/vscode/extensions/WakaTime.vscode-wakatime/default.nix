{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-wakatime";
    publisher = "WakaTime";
    version = "25.5.1";
    hash = "sha256-4wdY8cmKWfp/ua39lcD8ibxoy8W0zyX97vMyDEZu2o4=";
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
