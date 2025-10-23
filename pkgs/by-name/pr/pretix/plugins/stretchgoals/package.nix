{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pretix-plugin-build,
  setuptools,
}:

buildPythonPackage {
  pname = "pretix-stretchgoals";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rixx";
    repo = "pretix-stretchgoals";
    rev = "177238920a863f71cf03f174e2841f5b630574e9";
    hash = "sha256-Sbbxg6viRdALjZwqEmN2Js/qbMShe5xMg00jUccnhsA=";
  };

  build-system = [
    pretix-plugin-build
    setuptools
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [
    "pretix_stretchgoals"
  ];

  meta = with lib; {
    description = "Display the average ticket sales price over time";
    homepage = "https://github.com/rixx/pretix-stretchgoals";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
