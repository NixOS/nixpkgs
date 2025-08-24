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
          hash = "sha256-HXyY96fP9WjGWIe6ggQvygBnTEKRLUb5Qy18Vbjn160=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-2b04CLmbOxXsTzheEUacqZuBtA/rSZqRMLor0lT2gsU=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-/eKZ3bkZ2jFr8cTpNLO6t8wsRfLyhLkQHMrkTWtCWb8=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-JRVrV2yYSfuwuBcM2MDJZz5vNRYHG4n6I/GozgdDOgk=";
        };
      };
    in
    {
      name = "continue";
      publisher = "Continue";
      version = "1.1.76";
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
