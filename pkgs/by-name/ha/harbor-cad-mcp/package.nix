{
  lib,
  python3Packages,
  harbor-cad,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "harbor-cad-mcp";
  inherit (harbor-cad) version src;
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/python";

  build-system = [ python3Packages.hatchling ];

  dependencies = with python3Packages; [
    jsonschema
    mcp
  ];

  # runs the stdio server against a foreground CI-profile worker
  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  preCheck = ''
    export HARBOR_CAD_TEST_BINARY=${lib.getExe harbor-cad}
    export HARBOR_CAD_MCP_TEST_BINARY=$out/bin/harbor-cad-mcp
  '';

  enabledTestPaths = [ "tests/test_protocol.py" ];

  pythonImportsCheck = [ "harbor_cad_mcp.server" ];

  meta = {
    description = "Narrow MCP profiles for the local harbor-cad Rust worker";
    homepage = "https://github.com/caniko/harbor-cad";
    changelog = "https://github.com/caniko/harbor-cad/blob/v${finalAttrs.version}/python/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ caniko ];
    mainProgram = "harbor-cad-mcp";
    platforms = lib.platforms.linux;
  };
})
