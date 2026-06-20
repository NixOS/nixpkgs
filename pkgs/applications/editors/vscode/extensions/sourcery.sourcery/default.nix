{
  lib,
  stdenv,
  vscode-utils,
  autoPatchelfHook,
  zlib,
}:

let
  inherit (stdenv.hostPlatform) system;
in
vscode-utils.buildVscodeMarketplaceExtension (finalAttrs: {
  passthru.platformTable = {
    "x86_64-linux" = {
      arch = "linux-x64";
      hash = "sha256-Oz4Buraof4yXIxGeKXIsDkvEQQ0Gzf/b5mdses1nHlo=";
    };
    "x86_64-darwin" = {
      arch = "darwin-x64";
      hash = "sha256-Iqe4KZXQHenKAypXK/qzG2BCXbk2cZ0i/0xhWhlfQxo=";
    };
    "aarch64-darwin" = {
      arch = "darwin-arm64";
      hash = "sha256-vMDB5zmdBNt3R5AkeuCYhxzW/rSGwM+wtU5K4v3ZU/U=";
    };
  };

  mktplcRef = {
    name = "sourcery";
    publisher = "sourcery";
    version = "1.43.0";
  }
  // finalAttrs.passthru.platformTable.${system} or (throw "Unsupported platform ${system}");

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    zlib
  ];

  meta = {
    changelog = "https://sourcery.ai/changelog/";
    description = "VSCode extension for Sourcery, an AI-powered code review and pair programming tool for Python";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=sourcery.sourcery";
    homepage = "https://github.com/sourcery-ai/sourcery-vscode";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.attrNames finalAttrs.passthru.platformTable;
  };
})
