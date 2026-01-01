{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "markdownlint-cli";
<<<<<<< HEAD
  version = "0.47.0";
=======
  version = "0.46.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "igorshubovych";
    repo = "markdownlint-cli";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ZlUgkDu3mqZV83JswnIaNENlcrhFxujIT0DlaW2RO8M=";
  };

  npmDepsHash = "sha256-5rAp3Tw3cLhGQNbWiOCrR0l772fh4yW8qgVa+//OyRM=";
=======
    hash = "sha256-8yzTdgwKM2xSNJvqpQM/WSFVDVUDdFgpcIxr13thIYQ=";
  };

  npmDepsHash = "sha256-FQKjIAVvaAz4OsCZ1gKNLdHWhANdUKbFsD9HMksVu+U=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  dontNpmBuild = true;

  meta = {
    description = "Command line interface for MarkdownLint";
    homepage = "https://github.com/igorshubovych/markdownlint-cli";
    license = lib.licenses.mit;
    mainProgram = "markdownlint";
    maintainers = with lib.maintainers; [ ambroisie ];
  };
}
