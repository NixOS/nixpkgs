{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "rocq-mcp";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LLM4Rocq";
    repo = "rocq-mcp";
    tag = finalAttrs.version;
    hash = "sha256-EO7M6x/rboC41aYcyQbcJymqlYbIxir2P9Ib1CIO3kE=";
  };

  __structuredAttrs = true;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"pytanque @ git+https://github.com/LLM4Rocq/pytanque.git"' '"pytanque"'
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    mcp
    pytanque
  ];

  pythonImportsCheck = [ "rocq_mcp" ];

  meta = {
    description = "Model Context Protocol server for the Rocq/Coq proof assistant";
    homepage = "https://github.com/LLM4Rocq/rocq-mcp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ damhiya ];
    mainProgram = "rocq-mcp";
    platforms = lib.platforms.all;
  };
})
