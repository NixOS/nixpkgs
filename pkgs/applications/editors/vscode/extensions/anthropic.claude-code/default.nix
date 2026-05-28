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
          hash = "sha256-XfjNSoYIUEPgVI9deA9RDx2ur0oqIbDzvkYErfI0Fyw=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-/W5i1ODeA7YwsCb3gw0njQbf9WplsaZJZG84/czNxs4=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-fNsrRK6kaqqHgUD2TdvFni7nZXrAPdkC1dR2qFKdNas=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-4O/PZWXDHo+fcrNW7aDvUYc6x49k5CQNjy28KsgkpGM=";
        };
      };
    in
    {
      name = "claude-code";
      publisher = "anthropic";
      version = "2.1.154";
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
