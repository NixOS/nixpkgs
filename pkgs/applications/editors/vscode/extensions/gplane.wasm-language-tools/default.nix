{
  lib,
  vscode-utils,
  wasm-language-tools,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "gplane";
    name = "wasm-language-tools";
    version = "1.16.0";
    hash = "sha256-H2exVPaF8tYdpXBcooFi5bysp85OLOwxbKrB3HJes0Y=";
  };

  buildPhase = ''
    runHook preBuild
    ln -s ${wasm-language-tools}/bin bin
    runHook postBuild
  '';

  # The update script for the wasm-language-tools package itself updates this
  # package too, so we disable this update script to avoid sometimes
  # accidentally updating just this package by itself.
  enableUpdateScript = false;

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/gplane.wasm-language-tools/changelog";
    description = "Language support of WebAssembly";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=gplane.wasm-language-tools";
    homepage = "https://github.com/g-plane/vscode-wasm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ samestep ];
  };
}
