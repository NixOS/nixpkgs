{ lib, fetchPypi, pythonPackages, mopidy }:

pythonPackages.buildPythonApplication rec {
  pname = "Mopidy-Notify";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-lzZupjlS0kbNvsn18serOoMfu0sRb0nRwpowvOPvt/g=";
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
    maintainers = with maintainers; [ lilyinstarlight ];
  };
}
