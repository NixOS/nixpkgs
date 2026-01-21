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
          hash = "sha256-YPA0+kj5ATEpPSMqdqqtG0s/hlODSmme2i2vgfUiRvI=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-P/8SOKEK8y7gLPD/r88tDoMuh2AeCUd7hPA6Be7+YuU=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-QqHrephuGy+gq30HhRb/zjq3yEFQ6Vf3W6x2gaobObo=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-fhi3jgnl0Pu0WWHtOLEDlbgqNaGPJr6Ps3jxjhjvOBs=";
        };
      };
    in
    {
      name = "continue";
      publisher = "Continue";
      version = "1.2.11";
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
