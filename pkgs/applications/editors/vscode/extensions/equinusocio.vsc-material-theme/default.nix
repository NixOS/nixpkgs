{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vsc-material-theme";
    publisher = "Equinusocio";
    version = "34.7.5";
    hash = "sha256-6YMr64MTtJrmMMMPW/s6hMh/IilDqLMrspKRPT4uSpM=";
  };

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/Equinusocio.vsc-material-theme/changelog";
    description = "Most epic theme now for Visual Studio Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=Equinusocio.vsc-material-theme";
    homepage = "https://www.material-theme.dev/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ stunkymonkey ];
  };
}
