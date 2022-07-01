{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "dotfiles";
  version = "0.6.4";

  src = python3Packages.fetchPypi {
    inherit version pname;
    sha256 = "03qis6m9r2qh00sqbgwsm883s4bj1ibwpgk86yh4l235mdw8jywv";
  };

  # No tests in archive
  doCheck = false;

  checkInputs = with python3Packages; [ pytest ];
  propagatedBuildInputs = with python3Packages; [ click ];

  meta = with lib; {
    description = "Easily manage your dotfiles";
    homepage = "https://github.com/jbernard/dotfiles";
    license = licenses.isc;
  };
}
