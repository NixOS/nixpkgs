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
          hash = "sha256-G9+OpYGXT3mGgYTEcAv8Ls0NwmvX4TX77Cf4UMar3V8=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-Y2c2bYo7+rpsSvpfBc8mv4Nlp7Xl/kM+6FvdoMpr/bI=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-K2UEDbfIek8YJhbPHRxNCiSBV0Sj2rdRVospDtFMIds=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.32.1";
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
