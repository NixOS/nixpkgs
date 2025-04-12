{
  lib,
  python3,
  fetchFromGitHub,
  exabgp,
  testers,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "exabgp";
  version = "4.2.22";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Exa-Networks";
    repo = "exabgp";
    rev = "refs/tags/${version}";
    hash = "sha256-PrdCAmefKCBmbBFp04KiQGSsZZ4KNFk/ZtMedh9oow4=";
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
    changelog = "https://github.com/Exa-Networks/exabgp/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      hexa
      raitobezarius
    ];
  };
}
