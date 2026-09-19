{
  lib,
  pythonPackages,
  fetchPypi,
  mopidy,
}:

pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "mopidy-mpris";
  version = "4.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "mopidy_mpris";
    hash = "sha256-6cQlXxqno96SMQqlheAY3SkttVpEoVJmPjGndcJ4qQA=";
  };

  build-system = [
    pythonPackages.setuptools
    pythonPackages.setuptools-scm
  ];

  dependencies = [
    mopidy
    pythonPackages.pydbus
  ];

  doCheck = false;

  pythonImportsCheck = [ "mopidy_mpris" ];

  meta = {
    homepage = "https://www.mopidy.com/";
    description = "Mopidy extension for controlling Mopidy through D-Bus using the MPRIS specification";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.nickhu ];
  };
})
