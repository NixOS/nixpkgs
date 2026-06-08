{
  lib,
  fetchFromSourcehut,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "betula";
  version = "1.7.0";

  src = fetchFromSourcehut {
    owner = "~bouncepaw";
    repo = "betula";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8iDWWAL8JDZyKl3o0IJsWml410jh3cTPC2AoonvqiTI=";
  };
  vendorHash = "sha256-HGjaS2Sqsjk/pilt8wtx5Ect8Y8S5638PWEpXCqeZ6w=";

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
