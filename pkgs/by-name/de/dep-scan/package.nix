{
  lib,
  fetchFromGitHub,
  python3,
}:

let
  appthreat-vulnerability-db = (
    python3.pkgs.appthreat-vulnerability-db.overrideAttrs (oldAttrs: rec {
      version = "5.7.8";
      src = oldAttrs.src.override {
        rev = "refs/tags/v${version}";
        hash = "sha256-R00/a9+1NctVPi+EL7K65w/e88c9oSW5xXGgno+MCXo=";
      };
    })
  );

in
python3.pkgs.buildPythonApplication rec {
  pname = "dep-scan";
  version = "5.4.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "owasp-dep-scan";
    repo = "dep-scan";
    rev = "refs/tags/v${version}";
    hash = "sha256-QTvxKoqBxTb/xFaIHsYe3N+7ABJ6sDd2vVcjkMbm3xI=";
  };

  pythonRelaxDeps = [ "oras" ];

  build-system = with python3.pkgs; [ setuptools ];

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
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "depscan" ];

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
