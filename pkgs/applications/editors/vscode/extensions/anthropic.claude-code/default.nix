{
  lib,
  stdenv,
  stdenvNoCC,
  autoPatchelfHook,
  alsa-lib,
  testers,
  vscode-utils,
  vscode-extension-update-script,
}:

vscode-utils.buildVscodeMarketplaceExtension (finalAttrs: {
  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    (lib.getLib stdenv.cc.cc)
    alsa-lib
  ];

  mktplcRef =
    let
      sources = {
        "x86_64-linux" = {
          arch = "linux-x64";
          hash = "sha256-cDR/E5ATkKHUhvfQ+721M1DbNNxbSzWdnah7kEpyIxc=";
          signatureHash = "sha256-X18dx/5ZbDYA+nxHPwPUe9+smEemHPoDX/KGq+117Ls=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-8vJHvwYdCdQb0kHNbM6KNp27BJh8RGrBmw++Zz7nLf4=";
          signatureHash = "sha256-tB+7NtUaH96SjWzYrlgLmfFWtnqNT6wcHxqLQ8pFO0k=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-y93nqrqeLrOSPu+/NsKVg1yYPGT1x5XENO3VE/+uQU4=";
          signatureHash = "sha256-CAV+CiAY3Y+6uE5n1wjrk5ZNFrHEX0Shf7mDOLyVlJA=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-CYewM/KAk/WrEBiDK/aCkNc4/sGMIDnrHAoHIYU/h+o=";
          signatureHash = "sha256-btKfHI2TWuyf51UZnr+MnbrncDhVS2iiALIUOkSABus=";
        };
      };
    in
    {
      name = "claude-code";
      publisher = "anthropic";
      version = "2.1.123";
    }
    // sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system ${stdenvNoCC.hostPlatform.system}");

  passthru.tests.bundled-claude-runs = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "${finalAttrs.finalPackage}/share/vscode/extensions/anthropic.claude-code/resources/native-binary/claude --version";
  };

  meta = {
    description = "Harness the power of Claude Code without leaving your IDE";
    homepage = "https://docs.anthropic.com/s/claude-code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
