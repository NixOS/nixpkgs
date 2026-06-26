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
          hash = "sha256-4GiTNT+UPdTth9VDhHTXfqhQ5gM6vfLAaU5Cy3VMTCI=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-XJfDXWYpxYV5YHIBINqNJdyVho7Xd9OGMu11WE0LENM=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-QngCharrjiDKrY7RgWtKzIJxjXazuRvpuHVUAxknWfA=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-QPRZG7/Pjo9uboJl/RH0cdNf+zGM+ZRxdaMULxl34Jk=";
        };
      };
    in
    {
      name = "continue";
      publisher = "Continue";
      version = "2.0.0";
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
