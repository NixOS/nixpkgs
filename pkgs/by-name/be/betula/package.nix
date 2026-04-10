{
  lib,
  fetchFromSourcehut,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "betula";
  version = "1.5.0";

  src = fetchFromSourcehut {
    owner = "~bouncepaw";
    repo = "betula";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zrJkQNQmkp0JiXZL3YSPEkeavEJhu5KnONfOze9pttY=";
  };
  vendorHash = "sha256-8YDilb03J7fd6dj9CohvDDe9ylwXrrREvCP83yGpTyg=";

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
})
