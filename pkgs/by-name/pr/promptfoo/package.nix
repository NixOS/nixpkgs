{ buildNpmPackage
, fetchFromGitHub
, lib
}:

buildNpmPackage rec {
  pname = "promptfoo";
  version = "0.48.0";

  src = fetchFromGitHub {
    owner = "promptfoo";
    repo = "promptfoo";
    rev = "${version}";
    hash = "sha256-PFOwCjkkJncutYHTqoM21y4uh6X5LQiTSK+onzLT+uc=";
  };

  npmDepsHash = "sha256-Popm602xNKYZV4Q6sXFhHu978V8sCf5ujPPgJmlUzvc=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Test your prompts, models, RAGs. Evaluate and compare LLM outputs, catch regressions, and improve prompt quality.";
    mainProgram = "promptfoo";
    homepage = "https://www.promptfoo.dev/";
    changelog = "https://github.com/promptfoo/promptfoo/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ maintainers.nathanielbrough ];
  };
}
