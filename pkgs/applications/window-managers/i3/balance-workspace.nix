{ lib, buildPythonPackage, fetchPypi, i3ipc }:

buildPythonPackage rec {
  pname = "i3-balance-workspace";
  version = "1.8.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zJdn/Q6r60FQgfehtQfeDkmN0Rz3ZaqgNhiWvjyQFy0=";
  };

  propagatedBuildInputs = [ i3ipc ];

  doCheck = false;  # project has no test
  pythonImportsCheck = [ "i3_balance_workspace" ];

  meta = {
    description = "Balance windows and workspaces in i3wm";
    homepage = "https://pypi.org/project/i3-balance-workspace/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pacien ];
    mainProgram = "i3_balance_workspace";
  };
}
