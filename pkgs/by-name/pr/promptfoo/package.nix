{ buildNpmPackage
, fetchFromGitHub
, lib
}:

buildNpmPackage rec {
  pname = "promptfoo";
  version = "0.57.1";

  src = fetchFromGitHub {
    owner = "promptfoo";
    repo = "promptfoo";
    rev = "${version}";
    hash = "sha256-YjVnQmDfc6KBykAHPcRoM88Njlb6odhKWR0ZgFQSkVs=";
  };

  npmDepsHash = "sha256-sgcMtWPsikAuMCZ1h5IV4Ly+lO3/OKkTzGm8iFx3HiM=";

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
