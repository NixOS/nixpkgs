{
  lib,
  pythonPackages,
  fetchPypi,
  mopidy,
}:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-mpris";
  version = "3.0.3";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "Mopidy-MPRIS";
    hash = "sha256-rHQgNIyludTEL7RDC8dIpyGTMOt1Tazn6i/orKlSP4U=";
  };

  build-system = [
    pythonPackages.setuptools
  ];

  dependencies = [
    mopidy
    pythonPackages.pydbus
  ];

  doCheck = false;

  pythonImportsCheck = [ "mopidy_mpris" ];

  meta = with lib; {
    homepage = "https://www.mopidy.com/";
    description = "Mopidy extension for controlling Mopidy through D-Bus using the MPRIS specification";
    license = licenses.asl20;
    maintainers = [ maintainers.nickhu ];
  };
}
