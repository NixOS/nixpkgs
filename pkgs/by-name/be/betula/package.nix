{ lib
, fetchFromSourcehut
, buildGoModule
}: buildGoModule rec {
  pname = "betula";
  version = "1.1.0";

  src = fetchFromSourcehut {
    owner = "~bouncepaw";
    repo = "betula";
    rev = "v${version}";
    hash = "sha256-MH6YeWG94YVBgx5Es3oMJ9A/hAPPBXpAcIdCJV3HX78=";
  };
  vendorHash = "sha256-wiMIhoSO7nignNWY16OpDYZCguRbcEwwO/HggKSC5jM=";

  CGO_ENABLED = 1;
  # These tests use internet, so are failing in Nix build.
  # See also: https://todo.sr.ht/~bouncepaw/betula/91
  checkFlags = "-skip=TestTitles|TestHEntries";

  meta = with lib; {
    description = "Single-user self-hosted bookmarking software";
    homepage = "https://betula.mycorrhiza.wiki/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ GoldsteinE ];
  };
}
