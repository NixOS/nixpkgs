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
          hash = "sha256-yTkzftw8du9LlzIh36s+1JgLDR0DCQszJxqIdEksXvs=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-JRRmbJcP6YEoHfDnK69fJIsYRNB6qK1cRZUqk9JZNiI=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-zsU4lTCjebimApI4cnMSwtqYLAHqakwAUjk1W2gN7FE=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-rbGctv/AA7H4SsqUfFjNKv+5dE/JSN/2YRPIcD4Loxs=";
        };
      };
    in
    {
      name = "visualjj";
      publisher = "visualjj";
      version = "0.19.4";
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
