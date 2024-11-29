{
  lib,
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  fetchpatch,
  pythonOlder,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "py-dormakaba-dkey";
  version = "1.0.5";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "emontnemery";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-kS99du9EZwki6J2q+nI44rx/AWIPtq7wXR/61ZcyUSM=";
  };

  patches = [
    # https://github.com/emontnemery/py-dormakaba-dkey/pull/45
    (fetchpatch {
      name = "relax-setuptools-dependency.patch";
      url = "https://github.com/emontnemery/py-dormakaba-dkey/commit/cfda4be71d39f2cfd1c0d4f7fff9018050c57f1a.patch";
      hash = "sha256-JGsaLQNbUfz0uK/MeGnR2XTJDs4RnTOEg7BavfDPArg=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    bleak
    bleak-retry-connector
    cryptography
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "py_dormakaba_dkey" ];

  meta = with lib; {
    description = "Library to interact with a Dormakaba dkey lock";
    homepage = "https://github.com/emontnemery/py-dormakaba-dkey";
    changelog = "https://github.com/emontnemery/py-dormakaba-dkey/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
