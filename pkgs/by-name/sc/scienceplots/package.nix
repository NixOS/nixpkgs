{ lib
, python3Packages
, fetchPypi
}:

python3Packages.buildPythonPackage rec {
  pname = "SciencePlots";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2NGX40EPh+va0LnCZeqrWWCU+wgtlxI+g19rwygAq1Q=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    matplotlib
  ];

  meta = with lib; {
    description = "Matplotlib styles for scientific plotting";
    homepage = "https://github.com/garrettj403/SciencePlots";
    license = licenses.mit;
    maintainers = with maintainers; [ kilimnik ];
  };
}
