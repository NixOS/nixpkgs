{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "MatrixZulipBridge";
  version = "0.4.1";
  pyproject = true;

  disabled = python3Packages.pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "GearKite";
    repo = "MatrixZulipBridge";
    rev = "v${version}";
    hash = "sha256-5bDqZb8xx5SjThZUSmOcctwo6B15cjkIwA26QNfED2A=";
  };

  build-system = with python3Packages; [
    poetry-core
  ];

  dependencies = with python3Packages; [
    zulip
    beautifulsoup4
    bidict
    coloredlogs
    emoji
    markdownify
    mautrix
    python-dotenv
    ruamel-yaml
    zulip-emoji-mapping
  ];

  pythonRelaxDeps = [
    "bidict"
    "markdownify"
    "ruamel-yaml"
    "zulip-emoji-mapping"
  ];

  pythonImportsCheck = [
    "matrixzulipbridge"
  ];

  meta = {
    description = "Matrix puppeting appservice bridge for Zulip";
    homepage = "https://github.com/GearKite/MatrixZulipBridge";
    changelog = "https://github.com/GearKite/MatrixZulipBridge/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ robertrichter ];
    mainProgram = "matrix-zulip-bridge";
  };
}
