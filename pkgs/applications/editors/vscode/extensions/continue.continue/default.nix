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
          hash = "sha256-Ti/gMp0VFLwuvRlgUSQFP3WTDEhoXJZj5ebYiuIFmN0=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-I2DgC3r3okpzx5QvGY/b5DNrUThBD4kGRM93QT1A6RM=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-Hkf5QMp0Gi0eXhENZD8J8SEST4EDcefdMaF2/HZeBp8=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-evTcY9wXvvoHKeVmueBfOXCMb3dsQioQc/cmXON2D7M=";
        };
      };
    in
    {
      name = "continue";
      publisher = "Continue";
      version = "1.2.4";
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
