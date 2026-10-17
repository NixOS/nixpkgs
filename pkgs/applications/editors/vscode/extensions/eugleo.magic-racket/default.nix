{
  lib,
  jq,
  moreutils,
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
  nativeBuildInputs = [
    jq
    moreutils
  ];
  postInstall = ''
    cd "$out/$installPrefix"
    jq '.contributes.configuration.properties."magicRacket.general.racketPath".default = "${racket}/bin/racket"' package.json | sponge package.json
    jq '.contributes.configuration.properties."magicRacket.general.racoPath".default = "${racket}/bin/raco"' package.json | sponge package.json
  '';
  meta = {
    changelog = "https://marketplace.visualstudio.com/items/evzen-wybitul.magic-racket/changelog";
    description = "Best coding experience for Racket in VS Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=evzen-wybitul.magic-racket";
    homepage = "https://github.com/Eugleo/magic-racket";
    license = lib.licenses.agpl3Only;
  };
}
