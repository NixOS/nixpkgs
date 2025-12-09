{
  lib,
  fetchFromGitHub,
  python3,
  wireshark-cli,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "hfinger";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "hfinger";
    tag = "v${version}";
    hash = "sha256-gxwirAqtY4R3KDHyNmDIknABO+SFuoDua9nm1UyXbxA=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs =
    with python3.pkgs;
    [
      fnvhash
      python-magic
    ]
    ++ [
      wireshark-cli
    ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "hfinger"
  ];

  meta = {
    description = "Fingerprinting tool for HTTP requests";
    mainProgram = "hfinger";
    homepage = "https://github.com/CERT-Polska/hfinger";
    changelog = "https://github.com/CERT-Polska/hfinger/releases/tag/v${version}";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
