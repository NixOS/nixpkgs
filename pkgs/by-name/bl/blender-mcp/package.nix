{
  lib,
  python3Packages,
  fetchFromGitea,
}:

python3Packages.buildPythonPackage (finalAttrs: {
  pname = "blender-mcp";
  version = "1.0.3";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitea {
    domain = "projects.blender.org";
    owner = "lab";
    repo = "blender_mcp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pYeByO4Oi5eyynsJhGVd1vBWXHvhGn+Y5LGit6Kazlw=";
  };

  preConfigure = ''
    cd mcp
  '';

  pyproject = true;
  build-system = [ python3Packages.setuptools ];

  dependencies = [
    python3Packages.mcp_1
    python3Packages.docutils
    python3Packages.pyyaml
  ];

  # The addon lives at ../addon/ next to mcp/. Ship it so users can install it.
  postInstall = ''
    addon_out="$out/share/blender/scripts/addons/blender_mcp_addon"
    mkdir -p "$(dirname "$addon_out")"
    cp -r ../addon/blender_mcp_addon "$addon_out"
  '';

  # The upstream tests overwrite PYTHONPATH for the bridge subprocess instead of
  # appending to it, which works in a venv but not in the build sandbox. Use
  # --replace-fail so an upstream change to these lines fails the build instead
  # of silently skipping the subprocess tests.
  postPatch = ''
    substituteInPlace tests/test_mcp_server.py \
      --replace-fail \
      'env["PYTHONPATH"] = os.path.join(_REPO_DIR, "mcp")' \
      'env["PYTHONPATH"] = os.pathsep.join([_MCP_DIR, env.get("PYTHONPATH", "")])'
    substituteInPlace tests/test_tool_listing.py \
      --replace-fail \
      'env["PYTHONPATH"] = os.path.join(_REPO_DIR, "mcp")' \
      'env["PYTHONPATH"] = os.pathsep.join([os.path.join(_REPO_DIR, "mcp"), env.get("PYTHONPATH", "")])'
  '';

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-asyncio
  ];

  preCheck = ''
    cd ..
    export HOME="$TMPDIR"
  '';

  # This file needs a `blender` executable on PATH and a headless display
  # backend, neither of which exist in the build sandbox.
  disabledTestPaths = [ "tests/test_blender_mcp_with_blender.py" ];

  pythonImportsCheck = [ "blmcp" ];

  meta = {
    description = "MCP server for Blender";
    longDescription = ''
      A lightweight MCP (Model Context Protocol) server for Blender.
      It offers a natural language interface with Blender's Python API,
      improving access to documentation, and allowing users to explore
      and understand complex setups.
    '';
    homepage = "https://projects.blender.org/lab/blender_mcp";
    changelog = "https://projects.blender.org/lab/blender_mcp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ kitsunori ];
    mainProgram = "blender-mcp";
  };
})
