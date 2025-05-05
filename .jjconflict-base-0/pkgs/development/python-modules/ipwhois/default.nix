{
  lib,
  stdenv,
  buildPythonPackage,
  defusedxml,
  dnspython,
  fetchFromGitHub,
  iana-etc,
  libredirect,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ipwhois";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "secynic";
    repo = "ipwhois";
    tag = "v${version}";
    hash = "sha256-PY3SUPELcCvS/o5kfko4OD1BlTc9DnyqfkSFuzcAOSY=";
  };

  __darwinAllowLocalNetworking = true;

  pythonRelaxDeps = [ "dnspython" ];

  build-system = [ setuptools ];

  dependencies = [
    defusedxml
    dnspython
  ];

  nativeCheckInputs = [
    libredirect.hook
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ipwhois" ];

  preCheck = lib.optionalString stdenv.hostPlatform.isLinux ''
    echo "nameserver 127.0.0.1" > resolv.conf
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/resolv.conf=$(realpath resolv.conf)
  '';

  disabledTestPaths = [
    # Tests require network access
    "ipwhois/tests/online/"
    # Stress test
    "ipwhois/tests/stress/test_experimental.py"
  ];

  disabledTests = [
    "test_lookup"
    "test_unique_addresses"
    "test_get_http_json"
  ];

  meta = with lib; {
    description = "Library to retrieve and parse whois data";
    homepage = "https://github.com/secynic/ipwhois";
    changelog = "https://github.com/secynic/ipwhois/blob/v${version}/CHANGES.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
