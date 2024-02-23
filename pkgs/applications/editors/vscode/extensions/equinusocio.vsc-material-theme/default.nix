{ lib
, vscode-utils
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vsc-material-theme";
    publisher = "Equinusocio";
    version = "34.3.1";
    sha256 = "sha256-3yxFTMtjJR1b4EzBDfm55HF9chrya5OUF5wN+KHEduE=";
  };

  meta = with lib; {
    changelog = "https://marketplace.visualstudio.com/items/Equinusocio.vsc-material-theme/changelog";
    description = "The most epic theme now for Visual Studio Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=Equinusocio.vsc-material-theme";
    homepage = "https://github.com/material-theme/vsc-material-theme";
    license = licenses.asl20;
    maintainers = with maintainers; [ stunkymonkey ];
  };
}
