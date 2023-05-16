<<<<<<< HEAD
{ lib, python3Packages, fetchPypi }:
=======
{ lib, python3Packages }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

python3Packages.buildPythonApplication rec {
  pname = "dosage";
  version = "2.17";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3Packages.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

  disabled = python3Packages.pythonOlder "3.3";

  meta = {
    description = "A comic strip downloader and archiver";
    homepage = "https://dosage.rocks/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ toonn ];
  };
}
