{ lib
, fetchFromSourcehut
, buildGoModule
}: buildGoModule rec {
  pname = "betula";
  version = "1.2.0";

  src = fetchFromSourcehut {
    owner = "~bouncepaw";
    repo = "betula";
    rev = "v${version}";
    hash = "sha256-oxwOGpf305VDlY3Mwl0dRJRRhe0yolaMMlpNspZdKQk=";
  };
  vendorHash = "sha256-DjL2h6YKCJOWgmR/Gb0Eja38yJ4DymqW/SzmPG3+q9w=";

  CGO_ENABLED = 1;
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
