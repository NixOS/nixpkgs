{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "opencode";
  version = "0.0.34";

  src = fetchFromGitHub {
    owner = "opencode-ai";
    repo = "opencode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EaspkL0TEBJEUU3f75EhZ4BOIvbneUKnTNeNGhJdjYE=";
  };

  vendorHash = "sha256-cFzkMunPkGQDFhQ4NQZixc5z7JCGNI7eXBn826rWEvk=";

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
