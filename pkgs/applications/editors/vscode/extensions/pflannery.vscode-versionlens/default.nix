{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-versionlens";
    publisher = "pflannery";
    version = "1.28.0";
    hash = "sha256-IZjTHE51hdrQpDndsz5bBCKre0zmWkCAJa/v8k4iLy0=";
  };

  meta = {
    description = "Shows the latest version for each package using code lens";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=pflannery.vscode-versionlens";
    homepage = "https://gitlab.com/versionlens/vscode-versionlens";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ AlexAntonik ];
  };
}
