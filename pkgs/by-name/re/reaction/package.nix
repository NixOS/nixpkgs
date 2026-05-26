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
  version = "2.3.1";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "ppom";
    repo = "reaction";
    rev = "c0868d6fe1d155de183a89729b5f3f0ede7be4a2"; # TODO: return to tagged release
    hash = "sha256-QlSXZ2Wk1OXzAY2x6YjtW+xNchY+Ghb/6AsJgjfgoFE=";
  };

  cargoHash = "sha256-FYd7I93MAAzD6y0VMd9kMU7DAgS6v5CKt2KjrskaKeo=";

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
