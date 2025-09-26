{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stash-clipboard";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "NotAShelf";
    repo = "stash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s1/2Ur6dn8uEYU/g1MkNV4er8PDQPKZzPnE7La5hG2M=";
  };

  cargoHash = "sha256-13/tNRZPBNs8b7fSoFE4jAfxnT1x4OpzUBOdZwZndRM=";

  meta = {
    description = "Wayland clipboard manager with fast persistent history and multi-media support";
    homepage = "https://github.com/NotAShelf/stash";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      NotAShelf
      fazzi
    ];
    mainProgram = "stash";
  };
})
