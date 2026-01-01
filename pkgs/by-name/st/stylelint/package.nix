{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:
buildNpmPackage rec {
  pname = "stylelint";
<<<<<<< HEAD
  version = "16.26.1";
=======
  version = "16.26.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-klvYUuk1U6hClSWPQWwJv+uadjaEqkjOZv33PygyrCQ=";
  };

  npmDepsHash = "sha256-S1BYJDap3kW/MWZyv7Acmx+rFdGrWLwBdKlGPgH1RsU=";
=======
    hash = "sha256-Lw36rmGNoqobDoMdzYX7JaOFTyFGmjiBe55WI9RgAlY=";
  };

  npmDepsHash = "sha256-CCvyJzLCXbuipBXJrLdkAv/dT9RoZNhbwrUZhSaja8s=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  dontNpmBuild = true;

  meta = {
    description = "Mighty CSS linter that helps you avoid errors and enforce conventions";
    mainProgram = "stylelint";
    homepage = "https://stylelint.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ momeemt ];
  };
}
