{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "adafruit-nrfutil";
  version = "0.5.3.post17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adafruit";
    repo = "Adafruit_nRF52_nrfutil";
    rev = "refs/tags/${version}";
    hash = "sha256-mHHKOQE9AGBX8RAyaPOy+JS3fTs98+AFdq9qsVy7go4=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    click
    ecdsa
    pyserial
  ];

  nativeCheckInputs = with python3Packages; [
    behave
    nose
  ];

  preCheck = ''
    mkdir test-reports
  '';

  pythonImportsCheck = [
    "nordicsemi"
  ];

  meta = with lib; {
    homepage = "https://github.com/adafruit/Adafruit_nRF52_nrfutil";
    description = "Modified version of Nordic's nrfutil 0.5.x for use with the Adafruit Feather nRF52";
    license = licenses.bsd3;
    maintainers = with maintainers; [ stargate01 ];
  };
}
