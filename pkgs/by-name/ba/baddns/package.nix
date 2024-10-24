{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "baddns";
  version = "1.1.869";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "blacklanternsecurity";
    repo = "baddns";
    rev = "refs/tags/v${version}";
    hash = "sha256-BoRR7duvkXjI8vVP59IOACuIV7NmQe1loMEUgPfsdNw=";
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
    "test_cli_validation_customnameservers_valid"
    "test_modules_customnameservers"
    "test_references_cname_css"
    "test_references_cname_js"
  ];

  meta = {
    description = "Tool to check subdomains for subdomain takeovers and other DNS issues";
    homepage = "https://github.com/blacklanternsecurity/baddns/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "baddns";
  };
}
