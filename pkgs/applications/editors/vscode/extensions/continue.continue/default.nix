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
          hash = "sha256-4C8ug5B7xdd4rsmH9vsPkIerfF+tYniKn0tUk+zcNfg=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-OCp1wNWSl/Gg2IJhVGWmM677yqRa4y4UVAC+oypziIE=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-L2WwrZy0Aw7QO8060jW9rO8Dw6Fia450vvIWeW70uyU=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-t5h3/PoILd2/vcXIa0IK5Qx1uxNzHUdoUlRSSXK6bdw=";
        };
      };
    in
    {
      name = "continue";
      publisher = "Continue";
      version = "1.2.8";
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
