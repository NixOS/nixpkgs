{
  lib,
  vscode-utils,
  vscode-extension-update-script,
  jq,
  harper,
  moreutils,
  ...
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "harper";
    publisher = "elijah-potter";
    version = harper.version;
    hash = "sha256-Mu1l/3twbdpqIV8ePNfR7No23Ib/8hkB2CfE59BZP9M=";
  };

  nativeBuildInputs = [
    jq
    moreutils
  ];

  postInstall = ''
    cd "$out/$installPrefix"
    jq '.contributes.configuration.properties."harper.path".default = "${harper}/bin/harper-ls"' package.json | sponge package.json
  '';
  passthru.updateScript = vscode-extension-update-script { };

  meta = {
    changelog = "https://github.com/Automattic/harper/releases/tag/v${harper.version}";
    description = "The grammar checker for developers as a Visual Studio Code extension";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=elijah-potter.harper";
    homepage = "https://github.com/automattic/harper";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ MasterEvarior ];
  };
}
