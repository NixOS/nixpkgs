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
    "TestRunExec"
    "TestRunner"
    "Test_validateCmd"

    # Docker network request for image
    "TestImageExistsLocally"

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
  ]
  ++ lib.optionals stdenv.isDarwin [
    # Uses docker-specific options, unsupported on Darwin
    "TestMergeJobOptions"
  ];
in
buildGoModule (finalAttrs: {
  pname = "forgejo-runner";
  version = "12.6.4";

  src = fetchFromGitea {
    domain = "code.forgejo.org";
    owner = "forgejo";
    repo = "runner";
    rev = "v${finalAttrs.version}";
    hash = "sha256-v+b1YGUoIwzSGYUq/aUc5DceKUqWm0LA1Fd1/X/rf5w=";
  };

  vendorHash = "sha256-MrumzEpSuLVmtrySnlI7Nb7GqxmW8Yk9agsaH4HA6QU=";

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
