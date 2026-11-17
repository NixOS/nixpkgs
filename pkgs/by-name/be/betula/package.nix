{
  lib,
  fetchFromSourcehut,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "betula";
  version = "1.9.0";

  src = fetchFromSourcehut {
    owner = "~bouncepaw";
    repo = "betula";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SlXEYTHVTOil7zDagyJitDSkvZ90kiLt5oWEwsl0oSE=";
  };
  vendorHash = "sha256-hxW0++GFlL7Ljrqur4ZRIVIKKdTI9ncd8+CYcHKx/7g=";

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
