{
  lib,
<<<<<<< HEAD
  stdenv,
  nixosTests,
  rustPlatform,
  fetchFromGitLab,
  versionCheckHook,
  installShellFiles,
  nix-update-script,
=======
  fetchFromGitLab,
  rustPlatform,
  nix-update-script,
  installShellFiles,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "reaction";
  version = "2.2.1";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "ppom";
    repo = "reaction";
    tag = "v${finalAttrs.version}";
    hash = "sha256-81i0bkrf86adQWxeZgIoZp/zQQbRJwPqQqZci0ANRFw=";
  };

  cargoHash = "sha256-Bf9XmlY0IMPY4Convftd0Hv8mQbYoiE8WrkkAeaS6Z8=";

<<<<<<< HEAD
  nativeBuildInputs = [ installShellFiles ];

  # cross compiling for linux target
  buildInputs =
    lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform && stdenv.hostPlatform.isLinux)
      [
        stdenv.cc.libc
        (stdenv.cc.libc.static or null)
      ];
=======
  nativeBuildInputs = [
    installShellFiles
  ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  checkFlags = [
    # Those time-based tests behave poorly in low-resource environments (CI...)
    "--skip=daemon::filter::tests"
    "--skip=treedb::raw::tests::write_then_read_1000"
    "--skip=ip_pattern_matches"
  ];
  cargoTestFlags = [
    # Skip integration tests for the same reason
    "--lib"
  ];

  postInstall = ''
    installBin $releaseDir/ip46tables $releaseDir/nft46
    installManPage $releaseDir/reaction*.1
    installShellCompletion --cmd reaction \
      --bash $releaseDir/reaction.bash \
      --fish $releaseDir/reaction.fish \
      --zsh $releaseDir/_reaction
<<<<<<< HEAD
    mkdir -p $out/share/examples
    install -Dm444 config/example* config/README.md $out/share/examples
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };
  passthru.tests = { inherit (nixosTests) reaction reaction-firewall; };
=======
  '';

  passthru.updateScript = nix-update-script { };
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Scan logs and take action: an alternative to fail2ban";
    homepage = "https://framagit.org/ppom/reaction";
    changelog = "https://framagit.org/ppom/reaction/-/releases/v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    mainProgram = "reaction";
    maintainers = with lib.maintainers; [ ppom ];
<<<<<<< HEAD
    teams = [ lib.teams.ngi ];
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = lib.platforms.unix;
  };
})
