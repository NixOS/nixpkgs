{ lib, buildPythonPackage, fetchPypi, i3ipc }:

buildPythonPackage rec {
  pname = "i3-balance-workspace";
  version = "1.8.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gndzrwff8gfdqjjxv4zf2h2k0x7y97w1c3mrjpihz8xd0hbnk4d";
  };

  propagatedBuildInputs = [ i3ipc ];

  doCheck = false;  # project has no test
  pythonImportsCheck = [ "i3_balance_workspace" ];

  meta = {
    description = "Balance windows and workspaces in i3wm";
    homepage = "https://pypi.org/project/i3-balance-workspace/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pacien ];
  };
}
