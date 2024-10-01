{
  jq,
  lib,
  moreutils,
  tinymist,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "tinymist";
    publisher = "myriad-dreamin";
    inherit (tinymist) version;
    hash = "sha256-XkpoSf2UO3OoEMMpXBMkY1peQPR/4QoQ4LrY81IsHT0=";
  };

  nativeBuildInputs = [
    jq
    moreutils
  ];

  buildInputs = [ tinymist ];

  postInstall = ''
    cd "$out/$installPrefix"
    jq '.contributes.configuration.properties."tinymist.serverPath".default = "${lib.getExe tinymist}"' package.json | sponge package.json
  '';

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/myriad-dreamin.tinymist/changelog";
    description = "VSCode extension for providing an integration solution for Typst";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist";
    homepage = "https://github.com/myriad-dreamin/tinymist";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.drupol ];
  };
}
