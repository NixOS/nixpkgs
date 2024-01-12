{ buildNpmPackage
, fetchFromGitHub
, lib
}:

buildNpmPackage rec {
  pname = "promptfoo";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "promptfoo";
    repo = "promptfoo";
    rev = "${version}";
    hash = "sha256-IySt3qlRDzaVqkhaqr7yeAs3gemKgPNEUjpYANCZVVg=";
  };

  npmDepsHash = "sha256-uTNb/zMhnN8rElvG14YgUVuTTcayWPS5raGVo322g+I=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Test your prompts, models, RAGs. Evaluate and compare LLM outputs, catch regressions, and improve prompt quality.";
    homepage = "https://www.promptfoo.dev/";
    changelog = "https://github.com/promptfoo/promptfoo/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ maintainers.nathanielbrough ];
  };
}
