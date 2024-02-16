{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, pythonRelaxDepsHook
, click
, filetype
, gitpython
, jinja2
, jsonschema
, markdown
, packaging
, pdiff
, pillow
, pre-commit
, prompt-toolkit
, pytest
, pytest-workflow
, pyyaml
, questionary
, requests
, requests-cache
, rich
, rich-click
, tabulate
, trogon
}:

buildPythonPackage rec {
  pname = "nf-core";
  version = "2.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nf-core";
    repo = "tools";
    rev = version;
    hash = "sha256-LuJm6/v/RFQ999U0LznzsMp3Hnxi3r5cl2iOZ2BtnKE=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
    pythonRelaxDepsHook
  ];

  # NOTE Not going to support as it requires 10+ packages and is a niche feature
  pythonRemoveDeps = [
    "refgenie"
  ];

  propagatedBuildInputs = [
    click
    filetype
    gitpython
    jinja2
    jsonschema
    markdown
    packaging
    pdiff
    pillow
    pre-commit
    prompt-toolkit
    pytest
    pytest-workflow
    pyyaml
    questionary
    requests
    requests-cache
    rich
    rich-click
    setuptools
    tabulate
    trogon
  ];

  pythonImportsCheck = [ "nf_core" ];

  meta = with lib; {
    description = "Python package with helper tools for the nf-core community";
    homepage = "https://nf-co.re/tools";
    changelog = "https://github.com/nf-core/tools/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ edmundmiller ];
  };
}
