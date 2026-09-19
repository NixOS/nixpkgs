{
  lib,
  vscode-utils,
  air-formatter,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "air-vscode";
    publisher = "posit";
    version = "0.28.0";
    hash = "sha256-/B5Qzbndk4l+PyEWlODfIOkBPSVrh6Qi3gFrNmUjykE=";
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
