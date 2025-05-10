{
  lib,
  fetchFromGitHub,
  python3,
}:

let
  appthreat-vulnerability-db = (
    python3.pkgs.appthreat-vulnerability-db.overrideAttrs (oldAttrs: rec {
      version = "5.8.1";
      src = oldAttrs.src.override {
        tag = "v${version}";
        hash = "sha256-/Yo0yyDp2vd9KJhy3LGRml55eqTiaHSSuSoe2h2bSw0=";
      };
    })
  );

in
python3.pkgs.buildPythonApplication rec {
  pname = "dep-scan";
  version = "5.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "owasp-dep-scan";
    repo = "dep-scan";
    tag = "v${version}";
    hash = "sha256-lgqS8GY5JuHL3strNcb0B3mGieFkQTzGuRyV4dBp5e4=";
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
