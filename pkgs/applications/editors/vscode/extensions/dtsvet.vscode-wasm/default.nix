{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-wasm";
    publisher = "dtsvet";
    version = "1.4.1";
    hash = "sha256-zs7E3pxf4P8kb3J+5zLoAO2dvTeepuCuBJi5s354k0I=";
  };

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/dtsvet.vscode-wasm/changelog";
    description = "WebAssembly Toolkit for VSCode";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=dtsvet.vscode-wasm";
    homepage = "https://github.com/wasmerio/vscode-wasm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      frontear
    ];
  };
}
