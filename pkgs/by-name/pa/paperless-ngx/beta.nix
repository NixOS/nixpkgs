{
  paperless-ngx,
  fetchFromGitHub,
  fetchPnpmDeps,
  tesseract5,
  nix-update-script,
  pythonPackageOverrides ? null,
}:
(paperless-ngx.override {
  pythonPackageOverrides =
    if pythonPackageOverrides != null then
      pythonPackageOverrides
    else
      final: prev: {
        django = prev.django_5;

        # Drop the fido2 patch, paperless v3 uses latest v2

        # tesseract5 may be overwritten in the paperless module and we need to propagate that to make the closure reduction effective
        ocrmypdf = prev.ocrmypdf.override { tesseract = tesseract5; };
      };
}).overrideAttrs
  (prev: {
    version = "3.0.0-beta.rc1";

    src = fetchFromGitHub {
      inherit (prev.src) owner repo tag;
      hash = "sha256-dnPv+QUOm55bS8Ysk0cw4o9nP2pGRw16gF0G0kboxPU=";
    };

    nativeInstallCheckInputs = prev.nativeInstallCheckInputs ++ [
      prev.passthru.python.pkgs.time-machine
    ];

    disabledTests = prev.disabledTests ++ [
      # Requires network access to download tiktoken data
      "test_build_document_node"
      "test_update_llm_index"
      "test_update_llm_index_removes_meta"
      "test_update_llm_index_partial_update"
      "test_load_or_build_index_builds_when_nodes_given"
      "test_add_or_update_document_updates_existing_entry"
      "test_remove_document_deletes_node_from_docstore"
      "test_query_similar_documents"
      "test_get_ai_document_classification_success"
      "test_prompt_with_without_rag"
      "test_stream_chat_with_one_document_full_content"
      "test_stream_chat_with_multiple_documents_retrieval"
    ];

    pythonRelaxDeps = prev.pythonRelaxDeps ++ [
      "django-guardian"
      "filelock"
      "llama-index-core"
      "openai"
      "regex"
      "zxing-cpp"
    ];

    propagatedBuildInputs =
      prev.propagatedBuildInputs
      ++ (with prev.passthru.python.pkgs; [
        azure-ai-documentintelligence
        django-rich
        faiss-cpu
        ijson
        llama-index-core
        llama-index-embeddings-huggingface
        llama-index-embeddings-openai-like
        llama-index-llms-ollama
        llama-index-llms-openai-like
        llama-index-vector-stores-faiss
        openai
        sentence-transformers
        tantivy
        torch
        watchfiles
      ]);

    frontend = prev.frontend.overrideAttrs (prevFrontend: {
      pnpmDeps = fetchPnpmDeps {
        inherit (prevFrontend.pnpmDeps)
          pnpm
          fetcherVersion
          src
          version
          ;
        inherit (prev) pname;
        hash = "sha256-SOgMpS4Xq9VmXYzQjOzfN3lj1nf+dUc8pKUpbo6uvTk=";
      };
    });

    # v3 enforces a non-default PAPERLESS_SECRET_KEY at import time
    # since postBuild calls manage.py, this ends up getting triggered
    postBuild = ''
      export PAPERLESS_SECRET_KEY=super-safe-secret-key
      ${prev.postBuild}
    '';

    passthru = prev.passthru // {
      updateScript = nix-update-script {
        extraArgs = [
          "--version"
          "unstable"
          "--subpackage"
          "frontend"
          "--override-filename"
          "pkgs/by-name/pa/paperless-ngx/beta.nix"
        ];
      };
    };
  })
