{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "opencode";
  version = "0.0.46";

  src = fetchFromGitHub {
    owner = "opencode-ai";
    repo = "opencode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q7ArUsFMpe0zayUMBJd+fC1K4jTGElIFep31Qa/L1jY=";
  };

  vendorHash = "sha256-MVpluFTF/2S6tRQQAXE3ujskQZ3njBkfve0RQgk3IkQ=";

  checkFlags =
    let
      skippedTests = [
        # permission denied
        "TestBashTool_Run"
        "TestSourcegraphTool_Run"
        "TestLsTool_Run"
      ];
    in
    [ "-skip=^${lib.concatStringsSep "$|^" skippedTests}$" ];

  meta = {
    description = "Powerful terminal-based AI assistant providing intelligent coding assistance";
    homepage = "https://github.com/opencode-ai/opencode";
    mainProgram = "opencode";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      zestsystem
    ];
  };
})
