{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "sysdig-vscode-ext";
    publisher = "sysdig";
    version = "0.2.18";
    hash = "sha256-SzQ+q0gKHr3q7GNXoEiUtOjpfIt0gg9IZ3zogxtmx+0=";
  };

  meta = {
    description = "Scan your VS Code projects with Sysdig to investigate misconfigurations in IaC files or track vulnerabilities";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=sysdig.sysdig-vscode-ext";
    homepage = "https://github.com/sysdiglabs/vscode-extension";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tembleking ];
  };
}
