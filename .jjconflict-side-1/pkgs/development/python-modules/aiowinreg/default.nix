{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  prompt-toolkit,
  pythonOlder,
  setuptools,
  winacl,
}:

buildPythonPackage rec {
  pname = "aiowinreg";
  version = "0.0.12";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "skelsec";
    repo = "aiowinreg";
    rev = "refs/tags/${version}";
    hash = "sha256-XQDBvBfocz5loUg9eZQz4FKGiCGCaczwhYE/vhy7mC0=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    prompt-toolkit
    winacl
  ];

  # Project doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "aiowinreg" ];

  meta = with lib; {
    description = "Python module to parse the registry hive";
    homepage = "https://github.com/skelsec/aiowinreg";
    changelog = "https://github.com/skelsec/aiowinreg/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "awinreg";
  };
}
