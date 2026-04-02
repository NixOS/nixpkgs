{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "ioc-scan";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cisagov";
    repo = "ioc-scanner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oqXK98Im6OVItjSF8NCrGroE3w3k7QFzqpC2EEpa7N0=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  propagatedBuildInputs = with python3.pkgs; [ docopt ];

  nativeCheckInputs = with python3.pkgs; [
    pyfakefs
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ioc_scan" ];

  meta = {
    description = "Tool to search a filesystem for indicators of compromise (IoC)";
    homepage = "https://github.com/cisagov/ioc-scanner";
    changelog = "https://github.com/cisagov/ioc-scanner/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [ cc0 ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
