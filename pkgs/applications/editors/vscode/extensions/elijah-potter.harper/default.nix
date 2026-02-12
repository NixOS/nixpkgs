{
  stdenvNoCC,
  lib,
  vscode-utils,
  vscode-extension-update-script,
  jq,
  harper,
  moreutils,
  ...
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef =
    let
      sources = {
        "x86_64-linux" = {
          arch = "linux-x64";
          hash = "sha256-t5zyEIiELmto/yQBniF9JYn0VJIMdznryiWclyOwJxA=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-FcYzKA+DTTpfVomiTPPpLB5pFFYlvvMGChx6QtHzYOU=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-fvwf4FbLUZVm3Xvcf0ILmRYmCZJcIkQIgzT3VMtjkLY=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-aTAYGRZ816JYZHm+5MDxuTbrRgBSC0BkTUdREgBX+p0=";
        };
      };
    in
    {
      name = "harper";
      publisher = "elijah-potter";
      version = harper.version;
    }
    // sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system ${stdenvNoCC.hostPlatform.system}");

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
