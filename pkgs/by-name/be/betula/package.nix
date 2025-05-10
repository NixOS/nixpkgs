{
  lib,
  fetchFromSourcehut,
  buildGoModule,
}:
buildGoModule rec {
  pname = "betula";
  version = "1.4.0";

  src = fetchFromSourcehut {
    owner = "~bouncepaw";
    repo = "betula";
    rev = "v${version}";
    hash = "sha256-f2F0YRhDnKdMqcUvpcRFNAI62gbusfzIUKQSZ65onMU=";
  };
  vendorHash = "sha256-3PS4fIyHbGGjnbMOy2VIQBXsnIyYDKR/ecl/i5jwSVM=";

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
