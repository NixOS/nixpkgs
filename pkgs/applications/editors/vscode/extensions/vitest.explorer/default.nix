{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "explorer";
    publisher = "vitest";
    version = "1.52.2";
    hash = "sha256-/K5BpvWEt7Cxm4TlIjUIL4rxKs/oWJkwaHFhczAD0zE=";
  };
  meta = {
    changelog = "https://github.com/vitest-dev/vscode/releases";
    description = "Vitest extension for Visual Studio Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=vitest.explorer";
    homepage = "https://github.com/vitest-dev/vscode";
    license = lib.licenses.mit;
  };
}
