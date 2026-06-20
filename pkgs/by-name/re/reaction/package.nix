{
  lib,
  stdenv,
  callPackage,
  rustPlatform,
  fetchFromGitLab,

  versionCheckHook,
  installShellFiles,
  nix-update-script,

  nixosTests,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "reaction";
  version = "2.4.1";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "ppom";
    repo = "reaction";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1+kliU3TfXhAz/vRh/UamTdcv8UIXrcF1q+Qy1jsjD4=";
  };

  cargoHash = "sha256-FQCYCSKk8SLO2ddM6hklUuTvSK7+4dElaNQ3ZNnci3M=";

  nativeBuildInputs = [ installShellFiles ];

  # cross compiling for linux target
  buildInputs =
    lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform && stdenv.hostPlatform.isLinux)
      [
        stdenv.cc.libc
        (stdenv.cc.libc.static or null)
      ];

  checkFlags = [
    # Those time-based tests behave poorly in low-resource environments (CI...)
    "--skip=daemon::filter::tests"
    "--skip=treedb::raw::tests::write_then_read_1000"
    "--skip=ip_pattern_matches"
    # flaky and fails in hydra
    "--skip=concepts::config::tests::merge_config_distinct_concurrency"
  ];

  cargoTestFlags = [
    # Skip integration tests for the same reason
    "--lib"
  ];

  postInstall = ''
    installManPage $releaseDir/reaction*.1
    installShellCompletion --cmd reaction \
      --bash $releaseDir/reaction.bash \
      --fish $releaseDir/reaction.fish \
      --zsh $releaseDir/_reaction
    mkdir -p $out/share/examples
    install -Dm444 config/example* config/README.md $out/share/examples
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    inherit (callPackage ./plugins { }) mkReactionPlugin plugins;
    updateScript = nix-update-script { };
    tests = {
      inherit (nixosTests) reaction;
    }
    // finalAttrs.passthru.plugins;
  };

  meta = {
    changelog = "https://framagit.org/ppom/reaction/-/releases/v${finalAttrs.version}";
    description = "Scan logs and take action: an alternative to fail2ban";
    homepage = "https://framagit.org/ppom/reaction";
    license = lib.licenses.agpl3Plus;
    mainProgram = "reaction";
    maintainers = with lib.maintainers; [ ppom ];
    platforms = lib.platforms.unix;
    teams = [ lib.teams.ngi ];
  };
})
