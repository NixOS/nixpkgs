{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "beanprice";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beancount";
    repo = "beanprice";
    tag = "v${version}";
    hash = "sha256-Lhr8CRysZbI6dpPwRSN6DgvnKrxsIzH5YyZXRLU1l3Q=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    beancount
    curl-cffi
    diskcache
    python-dateutil
    regex
    requests
  ];

  nativeCheckInputs = with python3Packages; [
    click
    pytestCheckHook
    regex
  ];

  # Disable tests that require internet access
  disabledTestPaths = [
    "beanprice/price_test.py"
    "beanprice/sources/yahoo_test.py"
  ];

  pythonImportsCheck = [ "beanprice" ];

  meta = {
    broken = lib.versionOlder python3Packages.beancount.version "3";
    homepage = "https://github.com/beancount/beanprice";
    description = "Price quotes fetcher for Beancount";
    longDescription = ''
      A script to fetch market data prices from various sources on the internet
      and render them for plain text accounting price syntax (and Beancount).
    '';
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ alapshin ];
    mainProgram = "bean-price";
  };
}
