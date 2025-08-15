{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "bashplotlib";
  version = "0.6.5";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-sbWb5J1iVKW9gIkZ4KI6dacDoC5+hEeO3adlcU4L+u4=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  # No tests
  doCheck = false;

  meta = {
    homepage = "https://github.com/glamp/bashplotlib";
    description = "Plotting in the terminal";
    maintainers = with lib.maintainers; [ dtzWill ];
    license = lib.licenses.mit;
  };
}
