{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
<<<<<<< HEAD
  nix-update-script,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildNpmPackage {
  pname = "fixjson";
<<<<<<< HEAD
  version = "0-unstable-2023-01-06";
=======
  version = "1.1.2-unstable-2021-01-05";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "rhysd";
    repo = "fixjson";
    # Upstream has no tagged releases, but this commit bumps version
<<<<<<< HEAD
    rev = "c49f27a0268fca69021fa8aafc9bbef9960f82e9";
    hash = "sha256-Hse2EBppeEBoMQjRI97MNYWlRDpoOMhkZ/nbhpFgH5c=";
  };

  npmDepsHash = "sha256-mreSdJxFjSaz3kNoFC5ZSlBENA2sOLmsxS0VKW4o0z4=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
=======
    rev = "d0483f9cc59896ea59bb16f906f770562d332000";
    hash = "sha256-Mu7ho0t5GzFYuBK6FEXhpsaRxn9HF3lnvMxRpg0aqYI=";
  };

  npmDepsHash = "sha256-tnsgNtMdnrKYxcYy9+4tgp1BX+o8e5/HUDeSP5BOvUQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "JSON Fixer for Humans using (relaxed) JSON5";
    homepage = "https://github.com/rhysd/fixjson";
    license = lib.licenses.mit;
    mainProgram = "fixjson";
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
