{ lib, buildPythonApplication, fetchPypi, requests, pytestCheckHook }:

buildPythonApplication rec {
  pname = "gallery_dl";
  version = "1.16.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5926794d7a602cb9d4edf0a2094b266b790033db0a62689fa01e5272d7388587";
  };

  propagatedBuildInputs = [ requests ];

  checkInputs = [ pytestCheckHook ];
  pytestFlagsArray = [
    # requires network access
    "--ignore=test/test_results.py"
    "--ignore=test/test_downloader.py"
  ];

  meta = with lib; {
    description = "Command-line program to download image-galleries and -collections from several image hosting sites";
    homepage = "https://github.com/mikf/gallery-dl";
    license = licenses.gpl2;
    maintainers = with maintainers; [ dawidsowa ];
    platforms = platforms.unix;
  };
}
