{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitea,
  nixosTests,
  versionCheckHook,
  nix-update-script,
}:

let
  # tests which assume network access in some form
  disabledTests = [
    "Test_runCreateRunnerFile"
    "Test_ping"

    # The following tests were introduced in 9.x with the inclusion of act
    # the pkgs/by-name/ac/act/package.nix just sets doCheck = false;

    # Requires running docker install
    "TestDocker"
    "TestJobExecutor"
    "TestRunner"
    "Test_validateCmd"

    # Docker network request for image
    "TestImageExistsLocally"

    # Reaches out to different websites
    "TestFindGitRemoteURL"
    "TestGitFindRef"
    "TestGitCloneExecutor"
    "TestCloneIfRequired"
    "TestActionCache"
    "TestRunContext_GetGitHubContext"

    # These tests rely on outbound IP address
    "TestHandler"
    "TestHandler_gcCache"
  ];
in
buildGoModule rec {
  pname = "forgejo-runner";
  version = "11.1.2";

  src = fetchFromGitea {
    domain = "code.forgejo.org";
    owner = "forgejo";
    repo = "runner";
    rev = "v${version}";
    hash = "sha256-/rkBrG8hRn52M1ybjbWtSDFYsJ4fHzw9qAoc5325g9A=";
  };

  vendorHash = "sha256-eVOmUozNLHRiNwIhbf7ebVNdRiMAtLMdYI7pnALvl8U=";

  # See upstream Makefile
  # https://code.forgejo.org/forgejo/runner/src/branch/main/Makefile
  tags = [
    "netgo"
    "osusergo"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X code.forgejo.org/forgejo/runner/v11/internal/pkg/ver.version=${src.rev}"
  ];

  checkFlags = [
    "-skip ${lib.concatStringsSep "|" disabledTests}"
  ];

  postInstall = ''
    # fix up go-specific executable naming derived from package name, upstream
    # also calls it `forgejo-runner`
    mv $out/bin/runner $out/bin/forgejo-runner
    # provide old binary name for compatibility
    ln -s $out/bin/forgejo-runner $out/bin/act_runner
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/${meta.mainProgram}";
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script { };
    tests = lib.optionalAttrs stdenv.hostPlatform.isLinux {
      sqlite3 = nixosTests.forgejo.sqlite3;
    };
  };

  meta = with lib; {
    description = "Runner for Forgejo based on act";
    homepage = "https://code.forgejo.org/forgejo/runner";
    changelog = "https://code.forgejo.org/forgejo/runner/releases/tag/${src.rev}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      adamcstephens
      emilylange
      christoph-heiss
      tebriel
    ];
    mainProgram = "forgejo-runner";
  };
}
