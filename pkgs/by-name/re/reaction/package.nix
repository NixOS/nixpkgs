{
  lib,
  fetchFromGitLab,
  rustPlatform,
  nix-update-script,
  installShellFiles,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "reaction";
  version = "2.1.0";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "ppom";
    repo = "reaction";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3FJv1n1+cpV4yrBR6PKTAhSkjas/4uTZqn4nW948jAk=";
  };

  cargoHash = "sha256-Is8Mkl7Qfbe2CwYB+Da99NDQZd9+qR4NnT8iU/JMPJ0=";

  nativeBuildInputs = [
    installShellFiles
  ];

  checkFlags = [
    # Those time-based tests behave poorly in low-resource environments (CI...)
    "--skip=daemon::filter::tests"
    "--skip=treedb::raw::tests::write_then_read_1000"
    "--skip=simple"
  ];

  postInstall = ''
    installBin $releaseDir/ip46tables $releaseDir/nft46
    installManPage $releaseDir/reaction*.1
    installShellCompletion --cmd reaction \
      --bash $releaseDir/reaction.bash \
      --fish $releaseDir/reaction.fish \
      --zsh $releaseDir/_reaction
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Scan logs and take action: an alternative to fail2ban";
    homepage = "https://framagit.org/ppom/reaction";
    changelog = "https://framagit.org/ppom/reaction/-/releases/v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    mainProgram = "reaction";
    maintainers = with lib.maintainers; [ ppom ];
    platforms = lib.platforms.unix;
  };
})
