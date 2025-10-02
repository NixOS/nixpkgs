{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pylode";
  version = "2.13.3";
  pyproject = true;

  disabled = python3.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "RDFLib";
    repo = "pylode";
    tag = version;
    sha256 = "sha256-AtqkxnpEL+580S/iKCaRcsQO6LLYhkJxyNx6fi3atbE=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    beautifulsoup4
    falcon
    jinja2
    markdown
    python-dateutil
    rdflib
    requests
  ];

  pythonRelaxDeps = [ "rdflib" ];

  # Path issues with the tests
  doCheck = false;

  pythonImportsCheck = [
    "pylode"
  ];

  meta = with lib; {
    description = "OWL ontology documentation tool using Python and templating, based on LODE";
    homepage = "https://github.com/RDFLib/pyLODE";
    # Next release will move to BSD3
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ koslambrou ];
    mainProgram = "pylode";
  };
}
