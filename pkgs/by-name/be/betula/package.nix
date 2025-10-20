{
  lib,
  fetchFromSourcehut,
  buildGoModule,
}:
buildGoModule rec {
  pname = "betula";
  version = "1.5.0";

  src = fetchFromSourcehut {
    owner = "~bouncepaw";
    repo = "betula";
    rev = "v${version}";
    hash = "sha256-zrJkQNQmkp0JiXZL3YSPEkeavEJhu5KnONfOze9pttY=";
  };
  vendorHash = "sha256-8YDilb03J7fd6dj9CohvDDe9ylwXrrREvCP83yGpTyg=";

  env.CGO_ENABLED = 1;
  # These tests use internet, so are failing in Nix build.
  # See also: https://todo.sr.ht/~bouncepaw/betula/91
  checkFlags = "-skip=TestTitles|TestHEntries";

  meta = with lib; {
    description = "Single-user self-hosted bookmarking software";
    mainProgram = "betula";
    homepage = "https://betula.mycorrhiza.wiki/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ GoldsteinE ];
  };
}
