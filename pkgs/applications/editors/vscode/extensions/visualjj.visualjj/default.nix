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
          hash = "sha256-QOMJIhgc/dixPDUmir7bq5dWYGUfEWHJOlgTbGkxuDo=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-CucMSzmeYdrSbXZbevyJb3M2oTkyatddAt2MUMXNwl0=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-Lv/Hqp5OGC66qdIj/5VPlj434ftK4BBHNWlgg2ZAAac=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-KuAT8+8t6YlQ4VygtxGindvSRs1x7oKT9ZgE7Vhvf8I=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.16.1";
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
    maintainers = [ lib.maintainers.drupol ];
  };
}
