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
      hash = "sha256-zaMrQ0/w/gz3WW8/tVPBCPNAUookGs5yHLWjR3drZNE=";
    };
    "aarch64-darwin" = {
      arch = "darwin-arm64";
      hash = "sha256-fyfFyiuYwbtqChzTlfZ8E72ikQWOrlTAo7m9l9U/Eb8=";
    };
  };

  mktplcRef = {
    name = "sourcery";
    publisher = "sourcery";
    version = "1.44.0";
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
