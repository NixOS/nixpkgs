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
          hash = "sha256-eo/NsznwHU4IFTKcxI4eGJrutHzmY4PLigT+2B5uklk=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-T+bzAp9FkHdMU4Nklo7S37q0tnC91uIbgUOYSQNCkPo=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-LIPX1ri904wH7PKJE1uMHcefc1lXb1KV6TCDSph7P9o=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.35.0";
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
