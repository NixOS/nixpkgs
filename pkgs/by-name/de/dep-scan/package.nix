{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dep-scan";
  version = "5.2.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "owasp-dep-scan";
    repo = "dep-scan";
    rev = "refs/tags/v${version}";
    hash = "sha256-G8i/tGEDgjPnIP04nrbx4HseiaU6N1GJGSg78yhaqII=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace-fail " --cov-append --cov-report term --cov depscan" ""
    # Already fixed by upstream
    substituteInPlace pyproject.toml \
      --replace-fail "==5.6.4" ">=5.6.4"
  '';

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    appthreat-vulnerability-db
    cvss
    defusedxml
    jinja2
    oras
    packageurl-python
    pdfkit
    pygithub
    pyyaml
    quart
    rich
    toml
  ];

  nativeCheckInputs = with python3.pkgs; [
    httpretty
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "depscan"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # Test is not present
    "test_query_metadata2"
  ];

  meta = with lib; {
    description = "Security and risk audit tool based on known vulnerabilities, advisories, and license limitations for project dependencies";
    homepage = "https://github.com/owasp-dep-scan/dep-scan";
    changelog = "https://github.com/owasp-dep-scan/dep-scan/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "dep-scan";
  };
}
