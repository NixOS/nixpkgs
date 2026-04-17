{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "cozempic";
  version = "1.8.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EEBnR3isXLTTeVeihk/UEj4BIGa4lCMYUR0LdWue3Qo=";
  };

  build-system = [ python3Packages.setuptools ];

  # Zero runtime dependencies — Python stdlib only.
  pythonImportsCheck = [ "cozempic" ];

  meta = {
    description = "Context cleaning CLI for Claude Code — prune bloat, protect agent teams from compaction";
    homepage = "https://github.com/Ruya-AI/cozempic";
    changelog = "https://github.com/Ruya-AI/cozempic/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "cozempic";
    maintainers = with lib.maintainers; [ junaidtitan ];
    platforms = lib.platforms.all;
  };
}
