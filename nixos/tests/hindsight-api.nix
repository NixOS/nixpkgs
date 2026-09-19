{ lib, ... }:
{
  name = "hindsight-api";
  meta.maintainers = with lib.maintainers; [ gdifolco ];

  nodes.server = { ... }: {
    services.hindsight-api = {
      enable = true;
      host = "0.0.0.0";
      port = 8888;
      openFirewall = true;
      # No local LLM/embeddings/reranker runtime is packaged; hermetic provider
      # choices ("none" LLM, "rrf" reranker, lazy OpenAI embeddings) boot offline.
      settings = {
        HINDSIGHT_API_LLM_PROVIDER = "none";
        HINDSIGHT_API_EMBEDDINGS_PROVIDER = "openai";
        HINDSIGHT_API_EMBEDDINGS_OPENAI_API_KEY = "sk-test-dummy";
        HINDSIGHT_API_RERANKER_PROVIDER = "rrf";
        HINDSIGHT_API_SKIP_LLM_VERIFICATION = "true";
        HINDSIGHT_API_MODEL_INIT_TIMEOUT = "10";
      };
    };
  };

  testScript = ''
    start_all()

    server.wait_until_succeeds(
        "sudo -u postgres psql -d hindsight -tAc \"SELECT extname FROM pg_extension WHERE extname='vector'\" | grep -q vector",
        timeout=60,
    )

    server.wait_for_unit("hindsight-api.service", timeout=60)
    server.wait_until_succeeds("curl -fsS http://localhost:8888/health", timeout=90)
  '';
}
