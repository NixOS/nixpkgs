{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "dosage";
  version = "2.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vmxgn9wd3j80hp4gr5iq06jrl4gryz5zgfdd2ah30d12sfcfig0";
  };

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook pytest-xdist responses
  ];

  nativeBuildInputs = with python3Packages; [ setuptools-scm ];

  propagatedBuildInputs = with python3Packages; [
    colorama imagesize lxml requests setuptools six
  ];

  meta = {
    description = "Comic strip downloader and archiver";
    mainProgram = "dosage";
    homepage = "https://dosage.rocks/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ toonn ];
  };
}
