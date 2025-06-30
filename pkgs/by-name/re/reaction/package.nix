{
  lib,
  fetchFromGitLab,
  rustPlatform,
  nix-update-script,
  installShellFiles,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "reaction";
  version = "2.0.1";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "ppom";
    repo = "reaction";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HpnLh0JfGZsHcvDQSiKfW62QcCe/QDsVP/nGBo9x494=";
  };

  cargoHash = "sha256-i8KZygESxgty8RR3C+JMuE1aAsBxoLuGsL4jqjdGr0E=";

  nativeBuildInputs = [
    installShellFiles
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
    platforms = lib.platforms.linux;
  };
})
