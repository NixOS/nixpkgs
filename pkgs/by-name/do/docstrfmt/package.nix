{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "docstrfmt";
  version = "1.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LilSpazJoekp";
    repo = "docstrfmt";
    tag = "v${version}";
    hash = "sha256-5Yx+omXZSlpJSzA4dTY/JdfmHQshM7qI++OVvqYg1jc=";
  };

  build-system = [
    python3.pkgs.flit-core
  ];

  dependencies = with python3.pkgs; [
    black
    click
    docutils
    libcst
    platformdirs
    sphinx
    tabulate
    toml
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    pytest-aiohttp
  ];

  pythonImportsCheck = [
    "docstrfmt"
  ];

  meta = {
    description = "Formatter for reStructuredText";
    homepage = "https://github.com/LilSpazJoekp/docstrfmt";
    changelog = "https://github.com/LilSpazJoekp/docstrfmt/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "docstrfmt";
  };
}
