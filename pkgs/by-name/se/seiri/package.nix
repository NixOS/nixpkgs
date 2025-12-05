{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "seiri";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "tarolling";
    repo = "seiri";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bAf8btrNnWCq4eTlssa+o456rWkBfhXaypsai1OT1Ws=";
  };

  cargoHash = "sha256-qsyrYxdGtjiJmV1KuCLq8MpdZ+KxMIzLe4HKxNxcXK8=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language-agnostic project visualization tool";
    homepage = "https://github.com/tarolling/seiri";
    changelog = "https://github.com/tarolling/seiri/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "seiri";
  };
})
