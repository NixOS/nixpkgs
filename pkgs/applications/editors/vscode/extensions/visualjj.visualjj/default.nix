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
          hash = "sha256-tRTsU3wOUTG44PI6Pb8jkOusr9A0UoQDDSigCFac7xs=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-ZqaBCaTBrILQ3CA1MCE9FD78Xm4Sgs2l9uvcMjfJ7rc=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-iC6bTs3j3KqZUk6nA2o1zhlbMKhFAbJlLqv2KpDXXQI=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.33.5";
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
