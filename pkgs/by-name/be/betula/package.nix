{
  lib,
  fetchFromSourcehut,
  buildGoModule,
}:
buildGoModule rec {
  pname = "betula";
  version = "1.6.0";

  src = fetchFromSourcehut {
    owner = "~bouncepaw";
    repo = "betula";
    rev = "v${version}";
    hash = "sha256-14ws/iVVnvS6SRwco1iSBOZzYP6pIGhBwX5CDiwm93o=";
  };
  vendorHash = "sha256-PFvMZZUvHDE8onTxrqI53+gEFvZ42zJn4Q7gtDrmRdo=";

  env.CGO_ENABLED = 1;
  # These tests use internet, so are failing in Nix build.
  # See also: https://todo.sr.ht/~bouncepaw/betula/91
  checkFlags = "-skip=TestTitles|TestHEntries";

  meta = {
    description = "Single-user self-hosted bookmarking software";
    mainProgram = "betula";
    homepage = "https://betula.mycorrhiza.wiki/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ GoldsteinE ];
  };
}
