{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "stcgal";
  version = "1.10";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "grigorig";
    repo = "stcgal";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SM2wtpJ1F6sfBwfX+2124fLfTtVNjwa5NqsWrhORGhI=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    pyserial
    tqdm
    pyusb
  ];

  doCheck = false;

  pythonImportsCheck = [ "stcgal" ];

  meta = {
    description = "Command line flash programming tool for STC 8051 microcontrollers";
    homepage = "https://github.com/grigorig/stcgal";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Wu-XR ];
    mainProgram = "stcgal";
  };
})
