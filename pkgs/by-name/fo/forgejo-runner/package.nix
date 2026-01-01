{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitea,
  nixosTests,
  versionCheckHook,
  nix-update-script,
<<<<<<< HEAD
  gitMinimal,
  makeWrapper,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

let
  # tests which assume network access in some form
  disabledTests = [
    "Test_runCreateRunnerFile"
    "Test_ping"

    # The following tests were introduced in 9.x with the inclusion of act
    # the pkgs/by-name/ac/act/package.nix just sets doCheck = false;

<<<<<<< HEAD
    # Requires running Docker daemon
=======
    # Requires running docker install
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    "TestDocker"
    "TestJobExecutor"
    "TestRunner"
    "Test_validateCmd"

    # Docker network request for image
    "TestImageExistsLocally"

    # Reaches out to different websites
    "TestFindGitRemoteURL"
    "TestGitFindRef"
<<<<<<< HEAD
    "TestClone"
=======
    "TestGitCloneExecutor"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    "TestCloneIfRequired"
    "TestActionCache"
    "TestRunContext_GetGitHubContext"
    "TestSetJobResult_SkipsBannerInChildReusableWorkflow"

    # These tests rely on outbound IP address
    "TestHandler"
    "TestHandler_gcCache"
<<<<<<< HEAD
  ]
  ++ lib.optionals stdenv.isDarwin [
    # Uses docker-specific options, unsupported on Darwin
    "TestMergeJobOptions"
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];
in
buildGoModule rec {
  pname = "forgejo-runner";
<<<<<<< HEAD
  version = "12.4.0";
=======
  version = "11.3.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitea {
    domain = "code.forgejo.org";
    owner = "forgejo";
    repo = "runner";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-e7IDkeeEz8uAZ8WbRnBjSGq3SXVt5NY5li/3s/kf6dY=";
  };

  vendorHash = "sha256-oCSAehLC5NiL0Ttp+FeHQyTQYNh/59I1i0UfbwWPeRE=";

  nativeBuildInputs = [ makeWrapper ];
=======
    hash = "sha256-jvHnTCkRvYaejeCiPpr18ldEmxcAkrEIaOLVVBY11eg=";
  };

  vendorHash = "sha256-7Ybh5qzkqT3CvGtRXiPkc5ShTYGlyvckTxg4EFagM/c=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # See upstream Makefile
  # https://code.forgejo.org/forgejo/runner/src/branch/main/Makefile
  tags = [
    "netgo"
    "osusergo"
  ];

  ldflags = [
    "-s"
    "-w"
<<<<<<< HEAD
    "-X code.forgejo.org/forgejo/runner/v12/internal/pkg/ver.version=${src.rev}"
=======
    "-X code.forgejo.org/forgejo/runner/v11/internal/pkg/ver.version=${src.rev}"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  checkFlags = [
    "-skip ${lib.concatStringsSep "|" disabledTests}"
  ];

  postInstall = ''
<<<<<<< HEAD
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
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  passthru = {
    updateScript = nix-update-script { };
    tests = lib.optionalAttrs stdenv.hostPlatform.isLinux {
      sqlite3 = nixosTests.forgejo.sqlite3;
    };
  };

<<<<<<< HEAD
  meta = {
    description = "Runner for Forgejo based on act";
    homepage = "https://code.forgejo.org/forgejo/runner";
    changelog = "https://code.forgejo.org/forgejo/runner/releases/tag/${src.rev}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ nrabulinski ];
    teams = [ lib.teams.forgejo ];
=======
  meta = with lib; {
    # Cannot process container options: '--pid=host --device=/dev/sda': 'unknown server OS: darwin'
    broken = stdenv.hostPlatform.isDarwin;
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "forgejo-runner";
  };
}
