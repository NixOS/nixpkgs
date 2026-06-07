{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "sysdig-vscode-ext";
    publisher = "sysdig";
    version = "0.2.14";
    hash = "sha256-b4e5Qgk8YfI1nAB8yrM5k0svgebgZSucXRktkK0EItk=";
  };

  meta = {
    description = "Scan your VS Code projects with Sysdig to investigate misconfigurations in IaC files or track vulnerabilities";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=sysdig.sysdig-vscode-ext";
    homepage = "https://github.com/sysdiglabs/vscode-extension";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tembleking ];
  };
}
