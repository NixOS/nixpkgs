{
  lib,
  vscode-utils,
  air-formatter,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "air-vscode";
    publisher = "posit";
    version = "0.30.0";
    hash = "sha256-RAyXl111qODYMN0CiN/F+i6O3W0MvKdoV8Ap4dDzdsA=";
  };
  patchPhase = ''
    runHook prePatch
    rm bundled/bin/air
    ln -s "${lib.getExe air-formatter}" bundled/bin/air
    runHook postPatch
  '';
  meta = {
    changelog = "https://marketplace.visualstudio.com/items/Posit.air-vscode/changelog";
    description = "A Visual Studio Code extension for Air, an R formatter and language server, written in Rust.";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=Posit.air-vscode";
    homepage = "https://posit-dev.github.io/air";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.chvp ];
  };
}
