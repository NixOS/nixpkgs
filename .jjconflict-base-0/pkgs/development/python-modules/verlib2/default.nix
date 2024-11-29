{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  versioningit,
}:

buildPythonPackage rec {
  pname = "verlib2";
  version = "0.2.0";
  pyproject = true;

  # This tarball doesn't include tests unfortuneatly, and the GitHub tarball
  # could have been an alternative, but versioningit fails to detect the
  # version of it correctly, even with setuptools-scm and
  # SETUPTOOLS_SCM_PRETEND_VERSION = version added. Since this is a pure Python
  # package, we can rely on upstream to run the tests before releasing, and it
  # should work for us as well.
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CrlAh8CU4nFjlI36gXyY1itr3QEibM5RiPjMPNaDRbk=";
  };

  nativeBuildInputs = [
    setuptools
    versioningit
  ];

  pythonImportsCheck = [ "verlib2" ];

  meta = with lib; {
    description = "Standalone variant of packaging.version, without anything else";
    homepage = "https://pypi.org/project/verlib2/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ doronbehar ];
  };
}
