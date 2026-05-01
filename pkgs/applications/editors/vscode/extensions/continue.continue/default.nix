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
          hash = "sha256-NuJK5BjEsGeNQ2lBOHc5zPVzblwaS51hMUiYNtpQVlw=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-6+X7h6AHmCwTmH0gOoB9Mb8yEsmmyJEQ58sSVrqSTeA=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-mvYWAEKoQODGgZ4CaJ5xlGnwEBatMU2oecSM2hVmRog=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-5EsFUBJie2zNtlwJYIcFndkNPDDsZlUAggLwF1QESug=";
        };
      };
    in
    {
      name = "continue";
      publisher = "Continue";
      version = "1.2.10";
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
