{ lib
, python3
, fetchFromGitHub
, pre-commit
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nf-core";
  version = "2.12";
  version = "2.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nf-core";
    repo = "tools";
    rev = version;
    hash = "sha256-LuJm6/v/RFQ999U0LznzsMp3Hnxi3r5cl2iOZ2BtnKE=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    click
    filetype
    # gitpython
    jinja2
    jsonschema
    markdown
    packaging
    pdiff
    pre-commit
    prompt-toolkit
    pytest
    pytest-workflow
    pyyaml
    questionary
    refgenie
    requests
    requests-cache
    rich
    rich-click
    tabulate
  ];

  pythonImportsCheck = [ "nf_core" ];

  meta = with lib; {
    description = "Python package with helper tools for the nf-core community";
    homepage = "https://nf-co.re/";
    changelog = "https://github.com/nf-core/tools/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ edmundmiller ];
    mainProgram = "nf-core";
  };
}
