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
          hash = "sha256-41D15WSCK67DK1ArIOgbApndYYq6X0Br1cDajjkhHsE=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-gWBEMWsootSivCnPI0q0VqMvw3vaQUS+AYTrGd9mV20=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-Qs3+dRfHs3iZ+mS1uj6o4vPrMF66NgH/8Xmpyo6vTeE=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.35.4";
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
