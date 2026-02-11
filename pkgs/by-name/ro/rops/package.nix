{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rops";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "gibbz00";
    repo = "rops";
    tag = finalAttrs.version;
    hash = "sha256-Nqtwc9QSafvr0N8G6LKZBG4pZHzut3t85qwgVAw59iU=";
  };

  cargoHash = "sha256-EaelxmE53oKsWts9oK3LsK3uA8Vy3XbGUC1vKKBe37I=";

  # will true when tests is fixed from source.
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SOPS alternative in pure rust";
    homepage = "https://gibbz00.github.io/rops";
    changelog = "https://github.com/gibbz00/rops/blob/${finalAttrs.version}/CHANGELOG.md";
    mainProgram = "rops";
    maintainers = with lib.maintainers; [ r17x ];
    license = lib.licenses.mpl20;
  };
})
