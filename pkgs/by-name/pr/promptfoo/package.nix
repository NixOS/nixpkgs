{ buildNpmPackage
, fetchFromGitHub
, lib
}:

buildNpmPackage rec {
  pname = "promptfoo";
  version = "0.39.1";

  src = fetchFromGitHub {
    owner = "promptfoo";
    repo = "promptfoo";
    rev = "${version}";
    hash = "sha256-RnmvL3zcfWNqjnxCHNszGDAweKVT0GQ5GANJWVCRR/w=";
  };

  npmDepsHash = "sha256-OGYAYd1MCOFtdTgcsZcnWgTxtx28889RZhQ6fAe2HuI=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Test your prompts, models, RAGs. Evaluate and compare LLM outputs, catch regressions, and improve prompt quality.";
    homepage = "https://www.promptfoo.dev/";
    changelog = "https://github.com/promptfoo/promptfoo/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ maintainers.nathanielbrough ];
  };
}
