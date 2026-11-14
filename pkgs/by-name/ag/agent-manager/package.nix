{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  makeBinaryWrapper,
  git,
  procps,
  tmux,
  versionCheckHook,
  nix-update-script,
}:

buildGo127Module (finalAttrs: {
  pname = "agent-manager";
  __structuredAttrs = true;
  version = "0.43.1";

  src = fetchFromGitHub {
    owner = "YoanWai";
    repo = "agent-manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H1vciNZfNeF3WNln7GW6bNB7NMz3soHp9zo4d1GLxos=";
  };

  vendorHash = "sha256-iIYkIqpO2gjcC8z8jCc57akV0As2CjZQ75FguTmtKqA=";

  # only the root package is a program for users; the rest are repo tooling and examples
  excludedPackages = [
    "examples"
    "tools"
  ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  nativeCheckInputs = [
    git
    procps
    tmux
  ];

  checkFlags =
    let
      skippedTests = [
        # these tests expect the working directory to be inside a git
        # repository, but the fetched source has no .git directory
        "TestBoundMailboxToolsIgnoreAlternateProfile"
        "TestQuickWorktreeToggle"

        # the test runs a script with PATH=/usr/bin:/bin, where touch does
        # not exist in the build sandbox
        "TestAttachScriptTakesBackTheHostsRequest"

        # these tests start a pane running /bin/dash, which does not exist in
        # the build sandbox
        "TestRunInPaneDeliversALongCommandToAShellWithoutLineEditing"
        "TestRunInPaneLeavesTheAgentInFrontAndNoScript"
      ];
    in
    [ "-skip=^${lib.concatStringsSep "$|^" skippedTests}$" ];

  preCheck = ''
    # tests that start tmux and spawn sessions need an existing home directory
    export HOME=$(mktemp -d)
  '';

  postInstall = ''
    wrapProgram $out/bin/agent-manager \
      --prefix PATH : ${
        lib.makeBinPath [
          git
          tmux
        ]
      }
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal UI that runs coding agent CLIs side by side, each in its own tmux session";
    homepage = "https://agent-manager.dev";
    changelog = "https://github.com/YoanWai/agent-manager/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "agent-manager";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ YoanWai ];
  };
})
