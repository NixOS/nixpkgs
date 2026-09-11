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
  writableTmpDirAsHomeHook,
}:

let
  disabledTests = [
    # requires network
    "TestHandler"
    "TestClone"
    "TestRunner_ReusableWorkflowGitHubInstance"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # listen tcp 127.0.0.1:0: bind: operation not permitted
    "TestNewClient"
    # httptest: failed to listen on a port: listen tcp6 [::1]:0: bind: operation not permitted
    "TestNewEndpointHonoursTLSEnv"
  ];
in
buildGoModule (finalAttrs: {
  pname = "forgejo-runner";
  version = "13.1.0";

  src = fetchFromGitea {
    domain = "code.forgejo.org";
    owner = "forgejo";
    repo = "runner";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0LVia4B9n2zuuHDGFnBVM1mrbI7XBhMfy25kRSN5/WQ=";
  };

  vendorHash = "sha256-2QwltVOR6MJO8rLNgktN1ulvP0YrnqQorNnfJXzRmJs=";

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
    "-X code.forgejo.org/forgejo/runner/v13/internal/pkg/ver.version=${finalAttrs.src.rev}"
  ];

  checkFlags = [
    "-skip ${lib.concatStringsSep "|" disabledTests}"
  ];

  # Upstream offers '-args -features "-"' as go test flag to skip tests that require either lxc or docker.
  # Unfortunately, we cannot use this without patching buildGoModule, as -args passes the remainder of the
  # command line to the test binary, and checkFlags are templated between go test and $dir, causing $dir (e.g.
  # ./...) to be discarded, which in turn causes all tests to be skipped.
  # TODO: Make our buildGoModule (go/module.nix) template $dir before checkFlags to allow use of -arg
  # https://code.forgejo.org/forgejo/runner/pulls/1591
  # https://pkg.go.dev/cmd/go/internal/test#:~:text=%2Dargs
  preCheck = ''
    substituteInPlace testutils/test_main.go \
      --replace-fail 'TestFeatureDocker: {},' '// TestFeatureDocker: {},' \
      --replace-fail 'TestFeatureLXC:    {},' '// TestFeatureLXC:    {},'
  '';

  postInstall = ''
    # Fix up go-specific executable naming derived from package name, upstream
    # also calls it `forgejo-runner`
    mv $out/bin/runner $out/bin/forgejo-runner

    # Provide backward compatbility since v12 removed bundled git
    wrapProgram $out/bin/forgejo-runner --suffix PATH : ${lib.makeBinPath [ gitMinimal ]}

    # Provide old binary name for compatibility
    ln -s $out/bin/forgejo-runner $out/bin/act_runner
  '';

  nativeCheckInputs = [
    gitMinimal
    writableTmpDirAsHomeHook
  ];

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
