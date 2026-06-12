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
          hash = "sha256-XA4xSd/sg9vhOGqcCNliHzloBxPZsgXW/dSkKp/RzM0=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-l2NjDHBOMBzJT9Pis7sqSuFuG07eZPALximND+hVqDU=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-hE/1N28f9uAzg2fG3Hrc4z1kW21rdhtCRmF9SphqiFc=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-68CmDax385o0juoQWNX/NLx+tjIt9YytTHjRZkqAR98=";
        };
      };
    in
    {
      name = "claude-code";
      publisher = "anthropic";
      version = "2.1.175";
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
