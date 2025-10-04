{
  lib,
  python3,
  fetchFromGitHub,
  exabgp,
  testers,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "exabgp";
  version = "4.2.25";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Exa-Networks";
    repo = "exabgp";
    tag = version;
    hash = "sha256-YBxRDcm4Qt44W3lBHDwdvZq2pXEujbqJDh24JbXthMg=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  pythonImportsCheck = [
    "exabgp"
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = exabgp;
    };
  };

  meta = with lib; {
    description = "BGP swiss army knife of networking";
    homepage = "https://github.com/Exa-Networks/exabgp";
    changelog = "https://github.com/Exa-Networks/exabgp/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.bsd3;
    mainProgram = "exabgp";
    maintainers = with maintainers; [
      hexa
      raitobezarius
    ];
  };
}
