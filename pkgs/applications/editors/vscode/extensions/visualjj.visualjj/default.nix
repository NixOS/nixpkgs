{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "visualjj";
    publisher = "visualjj";
    version = "0.13.4";
    hash = "sha256-/uuLRkEY430R5RS7B6972iginpA3pWpApjI6RUTxcHM=";
  };

  meta = {
    description = "Jujutsu version control integration, for simpler Git workflow";
    downloadPage = "https://www.visualjj.com";
    homepage = "https://www.visualjj.com";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.drupol ];
  };
}
