{
  lib,
  fetchFromGitHub,
  buildGoModule,
  fzf,
  ripgrep,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "opencode";
  version = "0.0.52";

  src = fetchFromGitHub {
    owner = "opencode-ai";
    repo = "opencode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qIjSltfKB1xYutfG8eVf8ydJj1D863qN9jbC6gG6nXI=";
  };

  vendorHash = "sha256-Kcwd8deHug7BPDzmbdFqEfoArpXJb1JtBKuk+drdohM=";

  nativeCheckInputs = [
    fzf
    ripgrep
  ];

  checkFlags =
    let
      skippedTests = [
        # permission denied
        "TestBashTool_Run"
        "TestSourcegraphTool_Run"
        "TestLsTool_Run"

        # failing tests, seems to be fixed in dev. could try removing in > v0.0.52
        "TestGetContextFromPaths"
      ];
    in
    [ "-skip=^${lib.concatStringsSep "$|^" skippedTests}$" ];

  passthru.updateScript = nix-update-script { };

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
