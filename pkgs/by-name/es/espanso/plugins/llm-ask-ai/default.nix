{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
  python3,
  python3Packages,
}:
mkEspansoPlugin {
  pname = "llm-ask-ai";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "a5b6dbc16fa52e717f92a3667323cfd8646b47e0";
    hash = "sha256-QoQqI1cKgX9Xkl6u5t0TggrjiNsn0N+nZsRVGh812Mg=";
  };

  buildInputs = [
    python3
    python3Packages.openai
    python3Packages.python-dotenv
  ];

  meta = {
    description = "An Espanso package that enables users to quickly send prompts to a local (e.g. Ollama or LM Studio) or remote LLM API calls (OpenAI standard) and insert the AI-generated response directly into any text field.";
    license = lib.licenses.mit;
    homepage = "https://github.com/bgeneto/espanso-llm-ask-ai";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
