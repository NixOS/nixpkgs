{
  lib,
  fetchFromGitHub,
  gitMinimal,
  python3Packages,
}:

let
  pythonPackages = python3Packages.overrideScope (
    self: super: {
      pytest-randomly = super.pytest-randomly.overridePythonAttrs {
        doCheck = false;
      };
      sqlalchemy = self.sqlalchemy_1_4;
    }
  );
in
pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "quark-engine";
  version = "25.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "quark-engine";
    repo = "quark-engine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DAD37fzswY3c0d+ubOCYImxs4qyD4fhC3m2l0iD977A=";
  };

  build-system = with pythonPackages; [ setuptools ];

  dependencies = with pythonPackages; [
    androguard
    click
    colorama
    gitMinimal
    graphviz
    pandas
    plotly
    prettytable
    prompt-toolkit
    r2pipe
    rzpipe
    setuptools
    tqdm
  ];

  pythonRelaxDeps = [
    "r2pipe"
    "androguard"
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "quark" ];

  meta = {
    description = "Android malware (analysis and scoring) system";
    homepage = "https://quark-engine.readthedocs.io/";
    changelog = "https://github.com/quark-engine/quark-engine/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
