{
  stdenvNoCC,
  lib,
  vscode-utils,
  vscode-extension-update-script,
  stdenv,
  autoPatchelfHook,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef =
    let
      sources = {
        "x86_64-linux" = {
          arch = "linux-x64";
          hash = "sha256-1P3FEe67JgFRCE4fwphsAOiPGOf0D6Ocvy9ymWW7i0s=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-FnaAPIwBV6voGYHj31oWDzTJogTebvksnOJ6OBV3CL4=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-c/ScGJDpw96CgT8bQsGr8DJ4D8Pc1q1EVHesuY5ZNMI=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.37.2";
    }
    // sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system ${stdenvNoCC.hostPlatform.system}");

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  passthru.updateScript = vscode-extension-update-script { };

  meta = {
    description = "Jujutsu version control integration, for simpler Git workflow";
    homepage = "https://www.visualjj.com";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=visualjj.visualjj";
    changelog = "https://marketplace.visualstudio.com/items/visualjj.visualjj/changelog";
    license = lib.licenses.unfree;
    platforms = [
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [ sandarukasa ];
  };
}
