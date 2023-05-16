{ lib
, python3
<<<<<<< HEAD
, fetchPypi
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ablog";
  version = "0.11.4.post1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Zyvx7lVUQtjoGsSpFmH8pFrgTGgsFd4GMsL3fXKtUpU=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    docutils
    feedgen
    invoke
    packaging
    python-dateutil
    sphinx
    watchdog
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--rootdir" "src/ablog"
  ];
=======
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "ablog";
  version = "0.10.33.post1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+vrVQ4sItCXrSCzNXyKk6/6oDBOyfyD7iNWzmcbE/BQ=";
  };

  propagatedBuildInputs = [
    feedgen
    sphinx
    invoke
    watchdog
    python-dateutil
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  nativeBuildInputs = [ setuptools-scm ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "ABlog for blogging with Sphinx";
    homepage = "https://ablog.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ rgrinberg ];
  };
}
