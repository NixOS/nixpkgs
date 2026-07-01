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
          hash = "sha256-htZGjy7ZnQLGZUncokGaGHyLpvPM5jzWUvCdnfN1vbM=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-OFdrXunh63xBZW/HwDDjj17TTiOLGY1Enb6ARxNc4bI=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-rgeNJbl6G2yKAWYW7NarQwVLmd3oZ4YTOVeCUat6ZqQ=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-YBapB9XZ1/fUOflFDxZGT9rnPTumHQR/PfmyISHAAkY=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.30.0";
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
      "x86_64-darwin"
    ];
    maintainers = with lib.maintainers; [ sandarukasa ];
  };
}
