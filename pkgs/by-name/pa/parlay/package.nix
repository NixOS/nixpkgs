{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "parlay";
<<<<<<< HEAD
  version = "0.10.0";
=======
  version = "0.9.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "snyk";
    repo = "parlay";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-hyAvVd3P/ya7iSVsq3jbwe4qzJeWeA/hwAs2VTSIuAI=";
=======
    hash = "sha256-56N8eVsNvaK1gCJWk7h+C0w5DbBaDHH1DpIqmflc2e4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  vendorHash = "sha256-X/cgNdsUG0Ics/DCk1HOdzez9Ewwm1odFL1EiyFv1Sw=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Enriches SBOMs with data from third party services";
    homepage = "https://github.com/snyk/parlay";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kiike
    ];
    mainProgram = "parlay";
    platforms = lib.platforms.unix;
  };
}
