{
  lib,
  fetchFromSourcehut,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "betula";
  version = "1.9.1";

  src = fetchFromSourcehut {
    owner = "~bouncepaw";
    repo = "betula";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Nm9hitAgT04jozHGTAb0kUg2v/vBiafGJ/o4YfgZsmA=";
  };
  vendorHash = "sha256-IsElXsqzWC/9LCV9QCCfHTTi7iDEigNM7NInNj/LmP8=";

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
