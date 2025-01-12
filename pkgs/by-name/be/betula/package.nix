{ lib
, fetchFromSourcehut
, buildGoModule
}: buildGoModule rec {
  pname = "betula";
  version = "1.3.1";

  src = fetchFromSourcehut {
    owner = "~bouncepaw";
    repo = "betula";
    rev = "v${version}";
    hash = "sha256-20sA2Hnnppr2RXqu2Qx2bkU/u9FUkH6INUUGx2zKfao=";
  };
  vendorHash = "sha256-SWcQYF8LP6lw5kWlAVFt3qiwDnvpSOXenmdm6TSfJSc=";

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
