{
  lib,
  fetchFromGitHub,
  python3Packages,
  tesseract,
}:

python3Packages.buildPythonApplication rec {
  pname = "pdf-mcp";
  version = "1.21.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jztan";
    repo = "pdf-mcp";
    tag = "v${version}";
    hash = "sha256-/CuVdfkJkc95JkZZZMA5euvdysdPObRcww+zImhCY5M=";
  };

  build-system = [ python3Packages.hatchling ];

  pythonRelaxDeps = [
    "click"
    "joserfc"
    "mcp"
    "pydantic-settings"
  ];

  dependencies = with python3Packages; [
    click
    fastmcp
    httpx
    joserfc
    numpy
    pydantic
    pydantic-settings
    pymupdf
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ tesseract ])
    "--set-default"
    "TESSDATA_PREFIX"
    "${tesseract}/share/tessdata"
  ];

  pythonImportsCheck = [ "pdf_mcp" ];

  nativeCheckInputs = [
    tesseract
  ]
  ++ (with python3Packages; [
    pytestCheckHook
    pytest-asyncio
    pillow
  ]);

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # needs LLM API
  disabledTestPaths = [
    "tests/test_eval_coherence.py"
    "tests/test_release.py"
    "tests/test_demo_sample_pdf.py"
  ];

  # needs networking
  disabledTests = [ "test_rejects_text_html_content_type" ];

  pytestFlags = [
    "-m"
    "not slow"
    "--ignore-glob=*/test_benchmark_*.py"
  ];

  meta = {
    description = "MCP server that lets AI agents work through large PDFs without overflowing their context";
    homepage = "https://github.com/jztan/pdf-mcp";
    changelog = "https://github.com/jztan/pdf-mcp/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ derdennisop ];
    mainProgram = "pdf-mcp";
    platforms = lib.platforms.unix;
  };
}
