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
          hash = "sha256-zcP+oV7+xpXN5ZSvxw03XborEp2i9+3r1Hbv6sFq2rM=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-/nP0e3IHZtmsgTzNlJk9WOtg3jm6kpVGBaC5RMIvaII=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-WhIMbgMJE4FK83qmjCPobwNIzcGVU56jOw5v2Q4oIhU=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-gThzjcah7MWBKVkViDWJ5Z0epxy+9aWFpcFt4KI9zzQ=";
        };
      };
    in
    {
      name = "continue";
      publisher = "Continue";
      version = "1.2.9";
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
