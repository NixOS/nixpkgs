{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "language-gas-x86";
    publisher = "basdp";
    version = "0.0.2";
    hash = "sha256-PbXhOsoR0/5wXuFrzwCcauM1uGgfQoSRTj0gPVVZ4Kg=";
  };

  meta = {
    description = "GNU Assembler x86/x86_64 language support";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=basdp.language-gas-x86";
    homepage = "https://github.com/basdp/vscode-language-gas-x86";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.frontear ];
  };
}
