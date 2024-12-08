{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ready-check";
  version = "1.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sesh";
    repo = "ready";
    rev = "refs/tags/v${version}";
    hash = "sha256-j0UY2Q1jYGRtjvaWMwgMJrNaQZQnEJ5ST4o4PAVYWVc=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    thttp
    tld
  ];

  pythonImportsCheck = [
    "ready"
  ];

  meta = with lib; {
    description = "Tool to check readiness of websites";
    homepage = "https://github.com/sesh/ready";
    changelog = "https://github.com/sesh/ready/releases/tag/v${version}";
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
    mainProgram = "ready";
  };
}
