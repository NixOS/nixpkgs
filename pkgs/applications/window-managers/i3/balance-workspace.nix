{ lib, buildPythonPackage, fetchPypi, i3ipc }:

buildPythonPackage rec {
  pname = "i3-balance-workspace";
  version = "1.8.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7b5d72b756f79878a058484825bb343b100433e00a01f80c9c6d1ccc9f4af57a";
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
