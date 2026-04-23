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
          hash = "sha256-/D6d0qfgl8+cTEQ5ZeMjGgo1/Uzw5BxwBdM2m0fBjNU=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-jIyFt1ZLNPS4DbQLnZJ3p30AnPJz3qNFDj/rL6EdnKw=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-6At96R7jSDAjvC7Bugpg4L/aHgHFQmBOdKcOTa3Y940=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-GB/QLRmtY/cVs4lrU8OFnWgztJSF8e07VADIra/et2s=";
        };
      };
    in
    {
      name = "continue";
      publisher = "Continue";
      version = "1.2.22";
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
