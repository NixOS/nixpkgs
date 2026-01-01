{
  lib,
  fetchFromSourcehut,
  buildGoModule,
}:
buildGoModule rec {
  pname = "betula";
<<<<<<< HEAD
  version = "1.5.0";
=======
  version = "1.4.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromSourcehut {
    owner = "~bouncepaw";
    repo = "betula";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-zrJkQNQmkp0JiXZL3YSPEkeavEJhu5KnONfOze9pttY=";
  };
  vendorHash = "sha256-8YDilb03J7fd6dj9CohvDDe9ylwXrrREvCP83yGpTyg=";
=======
    hash = "sha256-f2F0YRhDnKdMqcUvpcRFNAI62gbusfzIUKQSZ65onMU=";
  };
  vendorHash = "sha256-3PS4fIyHbGGjnbMOy2VIQBXsnIyYDKR/ecl/i5jwSVM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  env.CGO_ENABLED = 1;
  # These tests use internet, so are failing in Nix build.
  # See also: https://todo.sr.ht/~bouncepaw/betula/91
  checkFlags = "-skip=TestTitles|TestHEntries";

<<<<<<< HEAD
  meta = {
    description = "Single-user self-hosted bookmarking software";
    mainProgram = "betula";
    homepage = "https://betula.mycorrhiza.wiki/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ GoldsteinE ];
=======
  meta = with lib; {
    description = "Single-user self-hosted bookmarking software";
    mainProgram = "betula";
    homepage = "https://betula.mycorrhiza.wiki/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ GoldsteinE ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
