{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stash-clipboard";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "NotAShelf";
    repo = "stash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NHsyzEjeIjfj5zZB7xoqilJtCzB7toLsxGbH781JD3g=";
  };

  cargoHash = "sha256-r1WEVjbu0U1S7b3KXV/yre2IdqGEdJ4JqBlx5OjPv10=";

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
