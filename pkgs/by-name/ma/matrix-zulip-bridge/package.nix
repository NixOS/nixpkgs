{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "MatrixZulipBridge";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GearKite";
    repo = "MatrixZulipBridge";
    rev = "v${finalAttrs.version}";
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
    changelog = "https://github.com/GearKite/MatrixZulipBridge/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ robertrichter ];
    mainProgram = "matrix-zulip-bridge";
  };
})
