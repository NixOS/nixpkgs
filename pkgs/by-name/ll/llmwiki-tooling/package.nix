{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "llmwiki-tooling";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "ilya-epifanov";
    repo = "llmwiki-tooling";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dW3YToi8IWg6iUrQ7esWHgJCz55aU9s+6f0CvnVh/RU=";
  };

  cargoHash = "sha256-9JTFYRhPEtFUx58t3P6X3sG6yC5FZfjoIpIYZCQJf88=";

  __structuredAttrs = true;

  meta = {
    description = "CLI for managing LLM-wikis with Obsidian-style wikilinks";
    homepage = "https://github.com/ilya-epifanov/llmwiki-tooling";
    changelog = "https://github.com/ilya-epifanov/llmwiki-tooling/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ ilya-epifanov ];
    mainProgram = "llmwiki-tool";
  };
})
