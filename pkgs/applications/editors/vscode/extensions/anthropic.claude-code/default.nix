{
  lib,
  stdenv,
  stdenvNoCC,
  autoPatchelfHook,
  alsa-lib,
  testers,
  vscode-utils,
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
          hash = "sha256-2o18oW1xrFwwp6Gb1aUY/4XFDiWUYeHSENiniizqOB4=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-Y7A0qTIOSwAt1+B0s3crlEQm6066CVm+SMSzd/2FQ5k=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-70u6O0Dhji5g4KDT3nrNvVOr8Wt7gh25ztT5rbDpe2U=";
        };
      };
    in
    {
      name = "claude-code";
      publisher = "anthropic";
      version = "2.1.291";
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
      "aarch64-darwin"
    ];
  };
})
