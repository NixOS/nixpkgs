{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hongdown";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "dahlia";
    repo = "hongdown";
    tag = finalAttrs.version;
    hash = "sha256-zk5pwiBonI24ZocnpzAbrZ1gfehm+hwjFUeUKcrCnMc=";
  };
  cargoHash = "sha256-62cj+gqXgrIqnH82mLFryKgoUJzY3Zw7P/MusYVZiIw=";
  meta = {
    description = "Markdown formatter that enforces Hong Minhee's Markdown style conventions";
    mainProgram = "hongdown";
    homepage = "https://github.com/dahlia/hongdown";
    changelog = "https://github.com/dahlia/hongdown/blob/main/CHANGES.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ wellmannmathis ];
  };
})
