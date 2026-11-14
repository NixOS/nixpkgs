{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "blueprint-gtk";
    publisher = "bodil";
    version = "0.2.0";
    hash = "sha256-A4H/o/HsjQKKee46VZJsjY7EB+1iOm4RWxHKcRLmkEY=";
  };

  meta = {
    description = "Gtk Blueprint language support";
    license = lib.licenses.lgpl3;
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=bodil.blueprint-gtk";
    maintainers = [ lib.maintainers.lyndeno ];
  };
}
