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
          hash = "sha256-VZKvoTJ/IKxYsEJl0XhtglsggmrYdaRUlXCpDv/9fQ0=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-jo+fET/IyOl2zI/xxYy3KwnyOegTOXFhO1hDg5QtWrQ=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-HOSKZjozJlWn++P5bSwWdK3I+fgsPtS8kyvDWHMJQAY=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-ABBYsSR3HQgSnnXUJXsg1DwqwFj9W6CT59/1fuqWsTc=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.29.0";
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
    downloadPage = "https://www.visualjj.com";
    homepage = "https://www.visualjj.com";
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
