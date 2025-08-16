{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "llm-prompts";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "A package with helpful prompts for AI Chat and LLMs like ChatGPT, Gemini, Claude, ...";
    homepage = "https://github.com/mmarschall/prompt-expander";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
