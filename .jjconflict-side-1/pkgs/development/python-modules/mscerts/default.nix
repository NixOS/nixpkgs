{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mscerts";
  version = "2024.5.29";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ralphje";
    repo = "mscerts";
    rev = "refs/tags/${version}";
    hash = "sha256-1k0k5BSEyiJ1Brx7P+sgUQI63k1eT59edghnPVuCuZE=";
  };

  build-system = [ setuptools ];

  # extras_require contains signify -> circular dependency

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "mscerts" ];

  meta = with lib; {
    description = "Makes the Microsoft Trusted Root Program's Certificate Trust Lists available in Python";
    homepage = "https://github.com/ralphje/mscerts";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
