{ pkgs
, stdenv
, pythonPackages
, fetchurl
}:

with pythonPackages;

buildPythonApplication rec {
  name = "jrnl-${version}";
  version = "1.9.7";
  disabled = isPy3k;

  src = fetchurl {
    url = "mirror://pypi/j/jrnl/${name}.tar.gz";
    sha256 = "af599a863ac298533685a7236fb86307eebc00a38eb8bb96f4f67b5d83227ec8";
  };

  propagatedBuildInputs = with pkgs; [
    pytz six tzlocal keyring argparse dateutil_1_5
    parsedatetime pycrypto
  ];

  meta = with stdenv.lib; {
    homepage = http://maebert.github.io/jrnl/;
    description = "A simple command line journal application that stores your journal in a plain text file";
    license = licenses.mit;
    maintainers = with maintainers; [ zalakain ];
  };
}
