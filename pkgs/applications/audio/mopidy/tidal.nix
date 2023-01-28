{ lib
, python3Packages
, mopidy
}:

python3Packages.buildPythonApplication rec {
  pname = "Mopidy-Tidal";
  version = "0.3.2";

  src = python3Packages.fetchPypi {
    inherit pname version;
    hash = "sha256-ekqhzKyU2WqTOeRR1ZSZA9yW3UXsLBsC2Bk6FZrQgmc=";
  };

  propagatedBuildInputs = [
    mopidy
    python3Packages.tidalapi
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-mock
  ];

  pytestFlagsArray = [ "tests/" ];

  meta = with lib; {
    description = "Mopidy extension for playing music from Tidal";
    homepage = "https://github.com/tehkillerbee/mopidy-tidal";
    license = licenses.mit;
    maintainers = [ maintainers.rodrgz ];
  };
}


