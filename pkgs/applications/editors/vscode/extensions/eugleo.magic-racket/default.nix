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
    version = "0.6.4";
    hash = "sha256-Hxa4VPm3QvJICzpDyfk94fGHu1hr+YN9szVBwDB8X4U=";
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
