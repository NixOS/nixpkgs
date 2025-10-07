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
          hash = "sha256-jhzV5mDEwnHPcCaH/ZF/nLPTYZJlOEJkoaPcTg4+uU8=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-nmT7hWHqmukyomTHIVM6k+bw0qgeeaehDNngiQgKid8=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-suJ/my6dovvxN2BdQKEbw8HeBi6o9WjPe/y9Uttq1QI=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-9+bCE3d6bNeVHnXNrJkWpK3UeVhy7cQrwYvSJ66Oufw=";
        };
      };
    in
    {
      name = "continue";
      publisher = "Continue";
      version = "1.2.6";
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
    maintainers = with lib.maintainers; [
      raroh73
      flacks
    ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
      "aarch64-linux"
    ];
  };
}
