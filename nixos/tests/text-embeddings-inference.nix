{ lib, ... }:
{
  name = "text-embeddings-inference";
  meta.maintainers = with lib.maintainers; [ gdifolco ];

  nodes.machine =
    { ... }:
    {
      services.text-embeddings-inference = {
        enable = true;
        # Small, publicly downloadable model (~90 MB) so cold start and warmup
        # stay fast. all-MiniLM-L6-v2 emits 384-dimensional embeddings.
        modelId = "sentence-transformers/all-MiniLM-L6-v2";
        openFirewall = true;
      };
    };

  testScript = ''
    import json

    machine.wait_for_unit("text-embeddings-inference.service")
    machine.wait_for_open_port(8080)

    # `/embed` returns a bare JSON array of embedding vectors (one per input).
    response = machine.succeed(
      """
      curl -fsS -X POST http://127.0.0.1:8080/embed \
        -H 'Content-Type: application/json' \
        -d '{"inputs":"hello world"}'
      """
    )

    embeddings = json.loads(response)
    assert isinstance(embeddings, list) and len(embeddings) == 1, (
      "unexpected /embed response: " + response[:200]
    )
    assert len(embeddings[0]) == 384, "expected a 384-dimensional vector"
  '';
}
