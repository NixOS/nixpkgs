{
  stdenvNoCC,
  lib,
  vscode-utils,
  vscode-extension-update-script,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef =
    let
      sources = {
        "x86_64-linux" = {
          arch = "linux-x64";
          hash = "sha256-Jqi9NTrKSweDpZ+YtXeiH77XPRgsKVJXlA4Fds7m8T0=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-8inRXcCkKbEm3D6+o5pEyUkkjj+58CgIGufHG5Qsl5Y=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-sTwJVM6XxbT2JAJWqAhMA/GJvP1GOnMfIezj+MMaiJ8=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-eJ/hKySxQDEh1hr36BAk0D7K6t4f9qj54T2Fc1Eq1t0=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.17.1";
    }
    // sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system ${stdenvNoCC.hostPlatform.system}");

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
    maintainers = [ ];
  };
}
