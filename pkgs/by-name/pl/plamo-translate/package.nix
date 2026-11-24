{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  llama-cpp,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  pythonPackages = python3Packages.overrideScope (
    final: prev: {
      # Upstream requires mcp < 2: it uses `FastMCP` and `streamablehttp_client`, which mcp v2 removed
      mcp = final.mcp_1;
    }
  );
in
pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "plamo-translate";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pfnet";
    repo = "plamo-translate-cli";
    tag = finalAttrs.version;
    hash = "sha256-d8DXxRqb6YiHC4+BGKOmNZ7DgceTan6tpaEWJlhN9a8=";
  };

  build-system = with pythonPackages; [ hatchling ];

  # Upstream requires mlx-lm < 0.32. With 0.32, only the PLaMo 2 MLX checkpoints fail to load,
  # because their `model_file` now requires trust_remote_code. The default PLaMo 3 models work.
  pythonRelaxDeps = [ "mlx-lm" ];

  dependencies =
    with pythonPackages;
    [
      httpx
      huggingface-hub
      mcp
      transformers
    ]
    ++ mcp.optional-dependencies.cli
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
      mlx-lm
      numba
    ];

  # The llama.cpp backend runs `llama-server`, which upstream expects the user to install.
  # This backend is the default where MLX is unavailable (e.g. Linux), and is selectable
  # with `--backend-type llama.cpp` on Apple Silicon.
  makeWrapperArgs = [
    "--set-default"
    "PLAMO_TRANSLATE_CLI_LLAMA_SERVER"
    (lib.getExe' llama-cpp "llama-server")
  ];

  nativeCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ (with pythonPackages; [
    jinja2
    pytestCheckHook
  ]);

  # - tests/test_cli.py runs the `plamo-translate` executable
  # - tests/test_model_selection.py expects MLX to be the default backend. Where MLX is
  #   unavailable (e.g. Linux), it is the default only with the mock server, as in upstream CI.
  preCheck = ''
    export PATH="$out/bin:$PATH"
    export PLAMO_TRANSLATE_CLI_USE_MOCK_SERVER=1
  '';

  disabledTestPaths = [
    # Need network access (download the real models)
    "tests/test_cli_integration.py"
    "tests/test_llama_cpp_integration.py"
  ];

  disabledTests = [
    # Loads a PLaMo 2 MLX export, which mlx-lm >= 0.32 refuses (see pythonRelaxDeps)
    "test_standalone_export_matches_corrected_cli_model"
  ];

  # Tests run an MCP server on localhost
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "plamo_translate" ];

  meta = {
    description = "CLI for local machine translation with PFN's PLaMo translation models";
    homepage = "https://github.com/pfnet/plamo-translate-cli";
    changelog = "https://github.com/pfnet/plamo-translate-cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ryota2357 ];
    mainProgram = "plamo-translate";
  };
})
