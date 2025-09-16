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
          hash = "sha256-xk2maMEa07yFPbLiDGc9N6AbzxjTyfVNy/k7wWSMOHE=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-vcN419nPIrFOT8EaznFzThst6exfMGRrcmxyuQttxXg=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-WoBfg35mGTIA8YZEk67iYNinF+Q/XEatiVr6x1HdvBk=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-e75eRgs0FTBnwFbH1vFxFc+aLK+O9TdxgXbV5YnsQLE=";
        };
      };
    in
    {
      name = "continue";
      publisher = "Continue";
      version = "1.2.2";
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
