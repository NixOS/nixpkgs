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
          hash = "sha256-0usn7rq41Z4kasiS0Rb+xw22EfQSYDyNsLFmkXkh2ow=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-7xtqbQeMSqP1qMlND0Oc25Idvww+hbwusZtfgSALI3s=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-Goksvv1cye+0WHUuLN/8QPCwkf/zcPzB9Xs7lvPS5p0=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-Sb9FKAkhyCHkN9PfucpKESLXqOrwNF/qE9QE4OW8hLI=";
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
