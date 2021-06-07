{ lib, buildPythonPackage, fetchPypi, i3ipc }:

buildPythonPackage rec {
  pname = "i3-balance-workspace";
  version = "1.8.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bb220eb373e290312b0aafe3d7b1cc1cca34c93189a4fca5bee93ef39aafbe3d";
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
