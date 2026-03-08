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
  version = "2.3.0";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "ppom";
    repo = "reaction";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OvNJsR9W5MlicqUpr1aOLJ7pI7H7guq1vAlC/hh1Q2o=";
  };

  patches = [
    # remove patch in next tagged version
    ./add-support-for-macos.patch
  ];

  cargoHash = "sha256-BOFZlVBKf6fjW1L1J8u7Vf+fzNJHlEtQI6YafDjlZ4U=";

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
    tests = nixosTests.reaction;
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
