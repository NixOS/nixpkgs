{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "teroshdl";
    publisher = "teros-technology";
    version = "7.0.3";
    hash = "sha256-Bt31ia0X4sQQfREq8PPVEGt/oGe/Oob0yQbYkwNRSsk=";
  };

  meta = {
    changelog = "https://github.com/TerosTechnology/vscode-terosHDL/releases";
    description = "Visual Studio Code extension for HDL developments (SystemVerilog/Verilog/VHDL)";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=teros-technology.teroshdl";
    homepage = "https://github.com/TerosTechnology/vscode-terosHDL";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ lheintzmann1 ];
  };
}
