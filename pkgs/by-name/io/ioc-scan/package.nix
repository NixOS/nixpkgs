{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ioc-scan";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cisagov";
    repo = "ioc-scanner";
    tag = "v${version}";
    hash = "sha256-Mo3J744WwWPoTdWeAKFLVD3rh/ZKOHbnfinMeC2Qqfo=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  propagatedBuildInputs = with python3.pkgs; [ docopt ];

  nativeCheckInputs = with python3.pkgs; [
    pyfakefs
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ioc_scan" ];

  meta = with lib; {
    description = "Tool to search a filesystem for indicators of compromise (IoC)";
    homepage = "https://github.com/cisagov/ioc-scanner";
    changelog = "https://github.com/cisagov/ioc-scanner/releases/tag/${src.tag}";
    license = with licenses; [ cc0 ];
    maintainers = with maintainers; [ fab ];
  };
}
