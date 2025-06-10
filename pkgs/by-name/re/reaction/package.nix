{
  lib,
  fetchFromGitLab,
  rustPlatform,
  nix-update-script,
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

  postBuild = ''
    $CC helpers_c/ip46tables.c -o ip46tables
    $CC helpers_c/nft46.c -o nft46
  '';

  postInstall = ''
    cp ip46tables nft46 $out/bin
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
