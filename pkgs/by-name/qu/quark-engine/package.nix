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
    }
  );
in
pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "quark-engine";
  version = "26.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ev-flow";
    repo = "quark-engine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EtTlhRQf+aLG0odF4/+l8vd8vzL/GP+ltIA8aMPPL9c=";
  };

  pythonRelaxDeps = [
    "androguard"
    "pathvalidate"
    "r2pipe"
  ];

  build-system = with pythonPackages; [ setuptools ];

  dependencies = with pythonPackages; [
    androguard
    click
    colorama
    dextrace
    gitMinimal
    graphviz
    pandas
    pathvalidate
    plotly
    prettytable
    prompt-toolkit
    r2pipe
    rzpipe
    setuptools
    tqdm
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "quark" ];

  meta = {
    description = "Android malware (analysis and scoring) system";
    homepage = "https://quark-engine.readthedocs.io/";
    changelog = "https://github.com/ev-flow/quark-engine/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
