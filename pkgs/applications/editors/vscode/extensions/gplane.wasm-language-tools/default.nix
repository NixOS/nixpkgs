{
  lib,
  vscode-utils,
  wasm-language-tools,
}:

# The update script for the wasm-language-tools package itself updates this
# package too, so we disable nixpkgs-update for this package to avoid sometimes
# accidentally updating just this package by itself.

# nixpkgs-update: no auto update

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "gplane";
    name = "wasm-language-tools";
    version = "1.20.0";
    hash = "sha256-AXLwEp6uospVZwd2NxLEfABsNQOt1uRJTQ4HMTXbrJc=";
  };

  buildPhase = ''
    runHook preBuild
    ln -s ${wasm-language-tools}/bin bin
    runHook postBuild
  '';

  meta = {
    description = "Language support of WebAssembly";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=gplane.wasm-language-tools";
    homepage = "https://github.com/g-plane/vscode-wasm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ samestep ];
  };
}
