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
          hash = "sha256-LfnJMvvMGgBdK9O+CgGff2YX5PSXrFybZ7aRrQ/jNIk=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-Yr9+CrndbxNDSbOwqXC4Gtskl6ms6vNac6Nzqew+yuQ=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-OZAz/saJ2DHtHEBfW0Hd8Tuq+wxwclL+VdGCyIyMrwo=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.33.6";
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
