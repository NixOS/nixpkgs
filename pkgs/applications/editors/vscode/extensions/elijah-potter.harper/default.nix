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

    # Because the binary is removed in favor of the harper package,
    # it does not matter which binary is fetched. Using only a single
    # hash makes this easier to maintain.
    arch = "linux-x64";
    hash = "sha256-/brjx/yY4JLLboI6dLwF/eyX7yhRyMlohhGNFGIrm54=";
  };

  nativeBuildInputs = [
    jq
    moreutils
  ];

  postInstall = ''
    cd "$out/$installPrefix"
    jq '.contributes.configuration.properties."harper.path".default = "${lib.getExe harper}"' package.json | sponge package.json

    rm ./bin/harper-ls
  '';

  passthru.updateScript = vscode-extension-update-script { };

  meta = {
    changelog = "https://github.com/Automattic/harper/releases/tag/v${harper.version}";
    description = "The grammar checker for developers as a Visual Studio Code extension";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=elijah-potter.harper";
    homepage = "https://github.com/automattic/harper";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ MasterEvarior ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
