{
  lib,
  racket,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "magic-racket";
    publisher = "evzen-wybitul";
    version = "0.9.0";
    hash = "sha256-EpSSSYoVnXHgJKoqSuMf/fTnGxAVqmc+RfXE5/HZ/C0=";
  };
  defaultConfig = {
    "magicRacket.general.racketPath" = racket;
    "magicRacket.general.racoPath" = lib.getExe' racket "raco";
  };
  meta = {
    changelog = "https://marketplace.visualstudio.com/items/evzen-wybitul.magic-racket/changelog";
    description = "Best coding experience for Racket in VS Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=evzen-wybitul.magic-racket";
    homepage = "https://github.com/Eugleo/magic-racket";
    license = lib.licenses.agpl3Only;
  };
}
