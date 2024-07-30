{ lib, fetchPypi, pythonPackages, mopidy }:

pythonPackages.buildPythonApplication rec {
  pname = "Mopidy-Notify";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8FT4O4k0wEsdHA1vJaOW9UamJ3QLyO47HwL5XcSU3Pc=";
  };

  propagatedBuildInputs = [
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
