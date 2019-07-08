{ stdenv
, python3
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "jrnl";
  version = "1.9.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d254c9c8f24dcf985b98a1d5311337c7f416e6305107eec34c567f58c95b06f4";
  };

  propagatedBuildInputs = [
    pytz six tzlocal keyring dateutil
    parsedatetime pycrypto
  ];

  # No tests in archive
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://maebert.github.io/jrnl/;
    description = "A simple command line journal application that stores your journal in a plain text file";
    license = licenses.mit;
    maintainers = with maintainers; [ zalakain ];
  };
}
