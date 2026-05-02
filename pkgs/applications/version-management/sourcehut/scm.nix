{
  lib,
  fetchFromSourcehut,
  buildPythonPackage,
  srht,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "scmsrht";
  version = "unstable-2025-09-17";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "scm.sr.ht";
    rev = "07aa1944a2c6";
    hash = "sha256-2VNJy5mNMsg6XHrrq+/qimF7hywbVlbmZZX6HebNnos=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    srht
  ];

  env = {
    SETUPTOOLS_SCM_PRETEND_VERSION = "0.0.0";
    PKGVER = version;
  };

  pythonImportsCheck = [ "scmsrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/scm.sr.ht";
    description = "Shared support code for sr.ht source control services";
    license = licenses.agpl3Only;
    maintainers = [ ];
  };
}
