{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "baddns";
  version = "1.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "blacklanternsecurity";
    repo = "baddns";
    rev = "refs/tags/v${version}";
    hash = "sha256-pF7HYl1l+TSahJHuyVBZtYeET6wPCiSi+Yi7Rg46T44=";
  };

  pythonRelaxDeps = true;

  build-system = with python3.pkgs; [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = with python3.pkgs; [
    colorama
    dnspython
    httpx
    python-dateutil
    python-whois
    pyyaml
    setuptools
    tldextract
  ];

  nativeCheckInputs = with python3.pkgs; [
    mock
    pyfakefs
    pytest-asyncio
    pytest-httpx
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "baddns" ];

  disabledTests = [
    # Tests require network access
    "test_cli_cname_http"
    "test_cli_direct"
    "test_cli_validation_customnameservers_valid"
    "test_cname_http_bigcartel_match"
    "test_cname_whois_unregistered_baddata"
    "test_cname_whois_unregistered_match"
    "test_cname_whois_unregistered_missingdata"
    "test_modules_customnameservers"
    "test_references_cname_css"
    "test_references_cname_js"
  ];

  meta = {
    description = "Tool to check subdomains for subdomain takeovers and other DNS issues";
    homepage = "https://github.com/blacklanternsecurity/baddns/";
    changelog = "https://github.com/blacklanternsecurity/baddns/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "baddns";
  };
}
