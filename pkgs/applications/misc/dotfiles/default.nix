{ stdenv, python2Packages }:

python2Packages.buildPythonApplication rec {
  pname = "dotfiles";
  name = "${pname}-${version}";
  version = "0.6.4";

  src = python2Packages.fetchPypi {
    inherit version pname;
    sha256 = "03qis6m9r2qh00sqbgwsm883s4bj1ibwpgk86yh4l235mdw8jywv";
  };

  # No tests in archive
  doCheck = false;

  checkInputs = with python2Packages; [ pytest ];
  propagatedBuildInputs = with python2Packages; [ click ];

  meta = with stdenv.lib; {
    description = "Easily manage your dotfiles";
    homepage = https://github.com/jbernard/dotfiles;
    license = licenses.isc;
  };
}
