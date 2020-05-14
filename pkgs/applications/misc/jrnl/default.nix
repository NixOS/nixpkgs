{ stdenv
, python3
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "jrnl";
  version = "2.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05m6h96mzw3fp6kyb49xipnv8vh8qmxg8mishfdjmx5zqwssc4qx";
  };

  propagatedBuildInputs = [
    ansiwrap
    asteval
    colorama
    dateutil
    keyring
    parsedatetime
    passlib
    pycrypto
    pytz
    pyyaml
    pyxdg
    six
    tzlocal
  ];

  # No tests in archive
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "http://maebert.github.io/jrnl/";
    description = "A simple command line journal application that stores your journal in a plain text file";
    license = licenses.mit;
    maintainers = with maintainers; [ zalakain ];
  };
}
