{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitea,
  nixosTests,
  versionCheckHook,
  nix-update-script,
  gitMinimal,
  makeWrapper,
}:

let
  # tests which assume network access in some form
  disabledTests = [
    "Test_runCreateRunnerFile"
    "Test_ping"

    # The following tests were introduced in 9.x with the inclusion of act
    # the pkgs/by-name/ac/act/package.nix just sets doCheck = false;

    # Requires running Docker daemon
    "TestDocker"
    "TestJobExecutor"
    "TestRunContext_PrepareJobContainer/Overlapping"
    "TestRunExec"
    "TestRunner"
    "Test_validateCmd"

    # Docker network request for image
    "TestImageExistsLocally"
    "TestStepDockerMain"

    # Reaches out to different websites
    "TestFindGitRemoteURL"
    "TestGitFindRef"
    "TestClone"
    "TestCloneIfRequired"
    "TestActionCache"
    "TestRunContext_GetGitHubContext"
    "TestSetJobResult_SkipsBannerInChildReusableWorkflow"

    # These tests rely on outbound IP address
    "TestHandler"
    "TestHandler_gcCache"

    # Timeouts
    "TestRunJob_WithConnectionFromCommandOptions"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Uses docker-specific options, unsupported on Darwin
    "TestMergeJobOptions"
    "TestNewEndpointHonoursTLSEnv"
  ];
in
buildGoModule (finalAttrs: {
  pname = "forgejo-runner";
  version = "12.11.1";

  src = fetchFromGitea {
    domain = "code.forgejo.org";
    owner = "forgejo";
    repo = "runner";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Qc43zWDDCjL8RW9Q30H4N5VRSFT3LR4Pt8/P0NcMacU=";
  };

  vendorHash = "sha256-du7fXehcxZ70Lsr5VCkz646G0Us/XwM4Sl98HXimoao=";

  nativeBuildInputs = [ makeWrapper ];

  # See upstream Makefile
  # https://code.forgejo.org/forgejo/runner/src/branch/main/Makefile
  tags = [
    "netgo"
    "osusergo"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X code.forgejo.org/forgejo/runner/v12/internal/pkg/ver.version=${finalAttrs.src.rev}"
  ];

  checkFlags = [
    "-skip ${lib.concatStringsSep "|" disabledTests}"
  ];

  postInstall = ''
    # Fix up go-specific executable naming derived from package name, upstream
    # also calls it `forgejo-runner`
    mv $out/bin/runner $out/bin/forgejo-runner

    # Provide backward compatbility since v12 removed bundled git
    wrapProgram $out/bin/forgejo-runner --suffix PATH : ${lib.makeBinPath [ gitMinimal ]}

    # Provide old binary name for compatibility
    ln -s $out/bin/forgejo-runner $out/bin/act_runner
  '';

  nativeCheckInputs = [ gitMinimal ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";

  passthru = {
    updateScript = nix-update-script { };
    tests = lib.optionalAttrs stdenv.hostPlatform.isLinux {
      latest = nixosTests.forgejo.sqlite3;
      lts = nixosTests.forgejo-lts.sqlite3;
    };
  };

  meta = {
    description = "Runner for Forgejo based on act";
    homepage = "https://code.forgejo.org/forgejo/runner";
    changelog = "https://code.forgejo.org/forgejo/runner/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ nrabulinski ];
    teams = [ lib.teams.forgejo ];
    mainProgram = "forgejo-runner";
  };
})
