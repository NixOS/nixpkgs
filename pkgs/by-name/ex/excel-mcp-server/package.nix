{
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "excel-mcp-server";
  version = "2.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "haris-musa";
    repo = "excel-mcp-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ERRHE0iT0uTFbgddX1lKsl7ZEzlBYgPQufkyrP/0HDU=";
  };

  # Upstream pins the uv_build release it was tested with; any recent one builds it.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"uv_build>=0.13.1,<0.14"' '"uv_build"'
  '';

  build-system = with python3Packages; [ uv-build ];

  dependencies = with python3Packages; [
    mcp
    olefile
    openpyxl
    pillow
    pydantic
    starlette
    uvicorn
  ];

  # Pillow is only used to read image sizes; the test suite passes with Pillow 12.
  pythonRelaxDeps = [ "pillow" ];

  nativeCheckInputs = [
    versionCheckHook
  ]
  ++ (with python3Packages; [
    pytest-timeout
    pytestCheckHook
  ]);

  disabledTestPaths = [
    # These start `python -m excel_mcp` through the MCP SDK, which passes the child a minimal
    # environment without PYTHONPATH, so it can't import its dependencies before installation.
    "tests/test_transports.py::test_stdio"
    "tests/test_transports.py::test_stdio_keeps_workbook_content_out_of_stderr"
  ];

  pythonImportsCheck = [ "excel_mcp" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MCP server for creating, reading and editing Excel workbooks without Microsoft Excel";
    homepage = "https://github.com/haris-musa/excel-mcp-server";
    changelog = "https://github.com/haris-musa/excel-mcp-server/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ slopinger ];
    mainProgram = "excel-mcp-server";
  };
})
