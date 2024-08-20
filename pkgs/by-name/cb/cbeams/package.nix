{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "cbeams";
  version = "1.0.3";
  disabled = !python3Packages.isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1agcjg6kmcyvk834xd2j60mi349qi9iw3dc2vwpd7pqwq1daq3gi";
  };

  postPatch = ''
    substituteInPlace cbeams/terminal.py \
      --replace-fail "blessings" "blessed"
  '';

  propagatedBuildInputs = with python3Packages; [ blessed docopt ];

  meta = with lib; {
    homepage = "https://github.com/tartley/cbeams";
    description = "Command-line program to draw animated colored circles in the terminal";
    license = licenses.bsd3;
    maintainers = with maintainers; [ oxzi ];
  };
}
