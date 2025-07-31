{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage (finalAttrs: {
  pname = "promptfoo";
  version = "0.79.0";

  src = fetchFromGitHub {
    owner = "promptfoo";
    repo = "promptfoo";
    rev = finalAttrs.version;
    hash = "sha256-sMBgjxPzG3SJ7RS4oTtOq7hJ1MYaKW3/6FF8Pn5l89c=";
  };

  npmDepsHash = "sha256-tnzeEFEc/BMN/VsoNHWJIWDOvupHfddqI6020Q4M0RM=";

  dontNpmBuild = true;

  meta = {
    description = "Test your prompts, models, RAGs. Evaluate and compare LLM outputs, catch regressions, and improve prompt quality";
    mainProgram = "promptfoo";
    homepage = "https://www.promptfoo.dev/";
    changelog = "https://github.com/promptfoo/promptfoo/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      nathanielbrough
      jk
    ];
  };
})
