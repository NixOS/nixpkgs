{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "knowsmore";
<<<<<<< HEAD
  version = "0.1.50";
=======
  version = "0.1.49";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "helviojunior";
    repo = "knowsmore";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-D3WhlReBwQLU+U/389r5gR73+DNvFiVuSr6NQgG2oFY=";
=======
    hash = "sha256-1qWbDf5lh9HogjjPoI51znpcQrriB2Eg4eA4xDQDYA8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

  enabledTestPaths = [ "tests/tests*" ];

  disabledTests = [
    # Issue with later neo4j versions
    "test_create_db"
  ];

<<<<<<< HEAD
  meta = {
    description = "Tool for pentesting Microsoft Active Directory";
    homepage = "https://github.com/helviojunior/knowsmore";
    changelog = "https://github.com/helviojunior/knowsmore/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Tool for pentesting Microsoft Active Directory";
    homepage = "https://github.com/helviojunior/knowsmore";
    changelog = "https://github.com/helviojunior/knowsmore/releases/tag/${src.tag}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "knowsmore";
  };
}
