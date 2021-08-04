{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "dosage";
  version = "2.17";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0vmxgn9wd3j80hp4gr5iq06jrl4gryz5zgfdd2ah30d12sfcfig0";
  };

  checkInputs = with python3Packages; [
    pytestCheckHook pytest-xdist responses
  ];

  propagatedBuildInputs = with python3Packages; [
    colorama imagesize lxml requests setuptools
  ];

  disabled = python3Packages.pythonOlder "3.3";

  meta = {
    description = "A comic strip downloader and archiver";
    homepage = "https://dosage.rocks/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ toonn ];
  };
}
