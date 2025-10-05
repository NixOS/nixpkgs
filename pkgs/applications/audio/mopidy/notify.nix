{
  lib,
  fetchPypi,
  pythonPackages,
  mopidy,
}:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-notify";
  version = "0.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "Mopidy-Notify";
    hash = "sha256-8FT4O4k0wEsdHA1vJaOW9UamJ3QLyO47HwL5XcSU3Pc=";
  };

  build-system = [
    pythonPackages.setuptools
  ];

  pythonRelaxDeps = [ "pykka" ];

  dependencies = [
    mopidy
    pythonPackages.pydbus
  ];

  nativeBuildInputs = [
    pythonPackages.pytestCheckHook
  ];

  pythonImportsCheck = [ "mopidy_notify" ];

  meta = with lib; {
    homepage = "https://github.com/phijor/mopidy-notify";
    description = "Mopidy extension for showing desktop notifications on track change";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
