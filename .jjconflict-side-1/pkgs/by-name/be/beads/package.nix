{
  lib,
  stdenv,
  buildGoModule,
  dolt,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
  icu,
  installShellFiles,
  makeBinaryWrapper,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "beads";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "gastownhall";
    repo = "beads";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QryUnK04c9Wm9/VgWoaOJW9M2HoZVZzSDMSMBtjKiyc=";
  };

  vendorHash = "sha256-DFS9dSZX3v3q3Yk6+bfnoEN1uIULs2h8t/P9W2tk6l8=";

  subPackages = [ "cmd/bd" ];

  ldflags = [
    "-s"
    "-w"
  ];

  buildInputs = [
    icu
  ];

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  nativeCheckInputs = [
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  # Workaround for: panic: httptest: failed to listen on a port: listen tcp6 [::1]:0: bind: operation not permitted
  # ref: https://github.com/NixOS/nix/pull/1646
  __darwinAllowLocalNetworking = true;

  checkFlags =
    let
      skippedTests = [
        # Upstream test bug: version gap 0.55.0->1.0.0 triggers "very old" warning instead of expected "ok"
        "TestCheckMetadataVersionTracking"
        # Installs a hook with a `#!/usr/bin/env sh` shebang, then exercises it via
        # `git worktree add`; /usr/bin/env doesn't exist in the Nix build sandbox
        "TestInstallHooksBeads_WorktreeAccess"
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        # Checks for /etc/passwd which isn't available in sandbox
        "TestCleanupMergeArtifacts_CommandInjectionPrevention"
        # Test-harness hygiene: reaps leaked `dolt sql-server` processes by
        # shelling out to `ps`, whose exec the Darwin build sandbox denies, so
        # the sweep finds nothing and the fake server outlives the assertion.
        # Nothing outside _test.go calls the swept code; `bd` is unaffected.
        "TestRunTestsAndSweepReapsOrphanedServer"
        # Both pin a proxied-server root at a literal /tmp path, so the workspace
        # gate they open lands in the host /tmp that Darwin builds share (it is
        # a sandbox-path, unlike the private /tmp a Linux build gets). The 0600
        # lock files outlive the build and belong to whichever _nixbld user ran
        # it, so the next build under a different user is denied.
        "TestMigrateToProxiedServer_AlreadyProxiedRejectsBadSidecar"
        "TestMigrateToProxiedServer_AlreadyProxiedRefusalsAreTyped"
      ];
    in
    [
      # cmd/bd is a ~1500-test, largely serial suite: most cases spawn a bd
      # subprocess backed by an embedded Dolt instance, so Go's 10m default
      # deadline expires mid-run and panics without naming a failing test.
      # 25m matches upstream's own per-package deadline in scripts/test.sh.
      "-timeout=25m"
      "-skip=^(${lib.concatStringsSep "|" skippedTests})$"
    ];

  preCheck = ''
    # Subprocess tests build their own bd binary (~45s each) unless pointed at
    # a prebuilt one. $out is not populated until installPhase, so hand them
    # the binary buildPhase just produced.
    export BEADS_TEST_BD_BINARY="$GOPATH/bin/bd"
    export PATH="$GOPATH/bin:$PATH"
  '';

  postInstall = ''
    wrapProgram $out/bin/bd \
      --prefix PATH : ${lib.makeBinPath [ dolt ]}
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd bd \
      --bash <($out/bin/bd completion bash) \
      --fish <($out/bin/bd completion fish) \
      --zsh <($out/bin/bd completion zsh)
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight memory system for AI coding agents with graph-based issue tracking";
    homepage = "https://github.com/gastownhall/beads";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kedry
      imcvampire
    ];
    mainProgram = "bd";
  };
})
