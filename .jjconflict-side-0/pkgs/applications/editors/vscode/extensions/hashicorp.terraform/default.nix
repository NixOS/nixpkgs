{
  lib,
  vscode-utils,
  terraform-ls,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "terraform";
    publisher = "hashicorp";
    version = "2.34.3";
    hash = "sha256-kE9xH0cp741aCqhrwFDW+lQxOAsdLNzCCOTWMxd+li0=";
  };

  postPatch = ''
    substituteInPlace dist/extension.js \
      --replace-fail 'this.customBinPath=Ga("terraform").get("languageServer.path")' 'this.customBinPath = Ga("terraform").get("languageServer.path") || '${terraform-ls}/bin/terraform-ls';'
  '';

  meta = {
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.rhoriguchi ];
  };
}
