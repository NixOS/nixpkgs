{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ioc-scan";
<<<<<<< HEAD
  version = "4.0.0";
=======
  version = "3.1.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cisagov";
    repo = "ioc-scanner";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-oqXK98Im6OVItjSF8NCrGroE3w3k7QFzqpC2EEpa7N0=";
=======
    hash = "sha256-Mo3J744WwWPoTdWeAKFLVD3rh/ZKOHbnfinMeC2Qqfo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = with python3.pkgs; [ setuptools ];

  propagatedBuildInputs = with python3.pkgs; [ docopt ];

  nativeCheckInputs = with python3.pkgs; [
    pyfakefs
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ioc_scan" ];

<<<<<<< HEAD
  meta = {
    description = "Tool to search a filesystem for indicators of compromise (IoC)";
    homepage = "https://github.com/cisagov/ioc-scanner";
    changelog = "https://github.com/cisagov/ioc-scanner/releases/tag/${src.tag}";
    license = with lib.licenses; [ cc0 ];
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Tool to search a filesystem for indicators of compromise (IoC)";
    homepage = "https://github.com/cisagov/ioc-scanner";
    changelog = "https://github.com/cisagov/ioc-scanner/releases/tag/${src.tag}";
    license = with licenses; [ cc0 ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
