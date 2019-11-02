{ stdenv, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  pname = "dotfiles";
  version = "0.6.4";

  src = pythonPackages.fetchPypi {
    inherit version pname;
    sha256 = "03qis6m9r2qh00sqbgwsm883s4bj1ibwpgk86yh4l235mdw8jywv";
  };

  # No tests in archive
  doCheck = false;

  checkInputs = with pythonPackages; [ pytest ];
  propagatedBuildInputs = with pythonPackages; [ click ];

  meta = with stdenv.lib; {
    description = "Easily manage your dotfiles";
    homepage = https://github.com/jbernard/dotfiles;
    license = licenses.isc;
  };
}
