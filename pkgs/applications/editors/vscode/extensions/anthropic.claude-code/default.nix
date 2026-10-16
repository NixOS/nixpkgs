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
          hash = "sha256-CxcRJM0kr9GWqHDqklgwnfv7l+a42NUl19uzIl/sxQA=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-g26KjS0tAj5aN+8WLwnEMTE6aiyNPJLRPvtD6rQklos=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-a9rAHqk4oYcM3FG/ghMci72SxHMuS3EzNVpsC56OP3g=";
        };
      };
    in
    {
      name = "claude-code";
      publisher = "anthropic";
      version = "2.1.301";
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
