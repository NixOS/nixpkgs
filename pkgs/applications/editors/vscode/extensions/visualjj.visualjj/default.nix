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
          hash = "sha256-YS/fX1utdHoPR2OgtQpvLA/gSePlfPieOGqgVrLiqQs=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-Z4sbBQ/wB/FlBh1K65AA2z9IWce11o2CSO12IJqTyZg=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-ovVwNVSHP0LNHOY8oGsV3JZ3N6wS0ZSpJfd6aPHpoS4=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.36.1";
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
