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
buildGoModule rec {
  pname = "forgejo-runner";
  version = "12.6.2";

  src = fetchFromGitea {
    domain = "code.forgejo.org";
    owner = "forgejo";
    repo = "runner";
    rev = "v${version}";
    hash = "sha256-Y5dX1iemh4o5dZrDyhWeMEiocpplEe66p8UadtbJ4Jw=";
  };

  vendorHash = "sha256-fvSiEIE4XSJ8Ot4Tcmt8chD11fHVsECD2/8xrgIKhJs=";

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
    "-X code.forgejo.org/forgejo/runner/v12/internal/pkg/ver.version=${src.rev}"
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
  versionCheckProgram = "${placeholder "out"}/bin/${meta.mainProgram}";

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
    changelog = "https://code.forgejo.org/forgejo/runner/releases/tag/${src.rev}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ nrabulinski ];
    teams = [ lib.teams.forgejo ];
    mainProgram = "forgejo-runner";
  };
}
