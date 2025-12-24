{
  lib,
  vscode-utils,
  wasm-language-tools,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "gplane";
    name = "wasm-language-tools";
    version = "1.15.0";
    hash = "sha256-PogHwExxQ9HjMEzh0ifqwk0KndLJLO8FkPVhiJSqvnQ=";
  };

  buildPhase = ''
    runHook preBuild
    ln -s ${wasm-language-tools}/bin bin
    runHook postBuild
  '';

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/gplane.wasm-language-tools/changelog";
    description = "Language support of WebAssembly";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=gplane.wasm-language-tools";
    homepage = "https://github.com/g-plane/vscode-wasm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ samestep ];
  };
}
