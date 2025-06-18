{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "cortex-debug";
    publisher = "marus25";
    version = "1.12.1";
    hash = "sha256-ioK6gwtkaAcfxn11lqpwhrpILSfft/byeEqoEtJIfM0=";
  };
  meta = {
    changelog = "https://marketplace.visualstudio.com/items/marus25.cortex-debug/changelog";
    description = "Visual Studio Code extension for enhancing debug capabilities for Cortex-M Microcontrollers";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=marus25.cortex-debug";
    homepage = "https://github.com/Marus/cortex-debug";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bcooley ];
  };
}
