{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "cai";
  version = "1.1.5-unstable-2026-06-05";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "aliasrobotics";
    repo = "cai";
    rev = "1c79507140845d0c57455e3b623e489680fd80e8";
    hash = "sha256-LcU9GoUulpeAaaBZr2Mg/C+UmjZ74UL+SGqdB0P9JtA=";
  };

  pythonRemoveDeps = [
    "cryptography"
    "dotenv"
    "openinference-instrumentation-openai"
    "pypdf2"
  ];

  pythonRelaxDeps = [ "openai" ];

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    cryptography
    curl-cffi
    dnspython
    docker
    fastapi
    flask
    folium
    graphviz
    griffe
    litellm
    mako
    matplotlib
    mcp
    mkdocs
    mkdocs-material
    nest-asyncio
    networkx
    numpy
    numpy
    openai
    openinference-instrumentation-openai
    pandas
    paramiko
    prompt-toolkit
    pydantic
    pypdf
    python-dotenv
    questionary
    requests
    rich
    textual
    trafilatura
    types-requests
    typing-extensions
    wasabi
    websockets
  ];

  nativeInstallCheckInputs = with python3Packages; [
    inline-snapshot
    litellm
    pytest-asyncio
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "cai" ];

  disabledTestPaths = [
    # Exclude examples
    "examples/"
    # API key is required
    "tests/agents/test_agent_inference.py"
    "tests/agents/test_agent_one_tool.py"
    "tests/agents/test_blue_teamer_gctr.py"
    "tests/api/test_api.py"
    "tests/cli/test_cli_headless_cancellation.py"
    "tests/commands/"
    "tests/integration/"
    "tests/refusals/"
    "tests/test_unified_pattern.py"
    "tools/tpm_test.py"
    # openai 2.x API changes
    "tests/cli/test_cli_streaming.py"
    "tests/core/test_openai_chatcompletions.py"
    "tests/core/test_openai_chatcompletions_stream.py"
    "tests/mcp/test_runner_calls_mcp.py"
    "tests/tracing/test_agent_tracing.py"
    "tests/tracing/test_responses_tracing.py"
    "tests/tracing/test_tracing.py"
    "tests/tracing/test_tracing_errors.py"
    "tests/tracing/test_tracing_errors_streamed.py"
    "tests/voice/test_workflow.py"
    # Missing symbols (version mismatch)
    "tests/core/test_auto_compact.py"
    "tests/core/test_context_optimization.py"
    # Probing the live interpreter outside sandbox
    "tests/continuous_ops/test_wizard_worker_python_bin.py"
    # Tests requires live CTF infrastructure
    "tests/ctfs/test_ctf.py"
    # Other error
    "tests/test_cli_print_deduplication.py"
    "tests/tools/test_output_tool.py"
    "tests/util/test_wait_hints_compact.py"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Framework for AI Security";
    homepage = "https://github.com/aliasrobotics/cai";
    changelog = "https://github.com/aliasrobotics/cai/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "cai";
  };
})
