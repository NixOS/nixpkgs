{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "knowsmore";
  version = "0.1.44";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "helviojunior";
    repo = "knowsmore";
    tag = "v${version}";
    hash = "sha256-m9rleUMQdBrgmeLcoFGIWRm4PKiwiEXONnIfFDxOrHs=";
  };

  pythonRelaxDeps = [
    "neo4j"
    "urllib3"
  ];

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    aioconsole
    ansi2image
    beautifulsoup4
    clint
    colorama
    impacket
    levenshtein
    minikerberos
    neo4j
    numpy
    pypsrp
    requests
    tabulate
    urllib3
    xmltodict
  ];

  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ];

  pythonImportsCheck = [ "knowsmore" ];

  pytestFlagsArray = [ "tests/tests*" ];

  meta = with lib; {
    description = "Tool for pentesting Microsoft Active Directory";
    homepage = "https://github.com/helviojunior/knowsmore";
    changelog = "https://github.com/helviojunior/knowsmore/releases/tag/${src.tag}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "knowsmore";
  };
}
