{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stash-clipboard";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "NotAShelf";
    repo = "stash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NSB7fl46S8Xtz0m6sMgUH//5fLmMja684CeHQVjcCpo=";
  };

  cargoHash = "sha256-k3H5geQHs2uIc2AWXYjEn6+sLae4Walg4jywkmZT0C4=";

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
