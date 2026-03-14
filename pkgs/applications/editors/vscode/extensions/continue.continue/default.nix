{
  autoPatchelfHook,
  lib,
  stdenv,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef =
    let
      sources = {
        "x86_64-linux" = {
          arch = "linux-x64";
          hash = "sha256-H4vW4KGVajCJ51kdiQ4Mg0U/U93oSflhc6MLrDsQSOM=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-goucET2PCGUFPCs8XS9MoisFPNS2uCZrJV/eINZ7kFk=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-Dp5p2QwFkd9gBrF7o9t8AVRgisGhhh9NHiTL9I/KGdg=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-LX7PIUf/8//WJraABTw+1Awt2oj3Q8pFNt4xLQvYgvw=";
        };
      };
    in
    {
      name = "continue";
      publisher = "Continue";
      version = "1.2.16";
    }
    // sources.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");
  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = [ (lib.getLib stdenv.cc.cc) ];
  meta = {
    changelog = "https://marketplace.visualstudio.com/items/Continue.continue";
    description = "Open-source AI code assistant";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=Continue.continue";
    homepage = "https://github.com/continuedev/continue";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ flacks ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
      "aarch64-linux"
    ];
  };
}
