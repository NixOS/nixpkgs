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
          hash = "sha256-YHerrkqMlLLHvbuM1fT6g4nBgO1DIkRBC+5ncw9ZA+I=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-iXRw+07xkSi6Gxhx+iezBaGlAaZM2L0BmzZ5ZfFUEbc=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-WkDu27TW1C+0UvNvNpWGKUhvqWo9rHMTWI9ro/gOYHs=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-5RDH+TAfSkEYIleb2gb9vg+akWXp2JDcSUqyHZNJh/M=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.28.3";
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
