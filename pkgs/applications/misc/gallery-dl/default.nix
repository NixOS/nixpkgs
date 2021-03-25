{ lib, buildPythonApplication, fetchPypi, requests, pytestCheckHook }:

buildPythonApplication rec {
  pname = "gallery_dl";
  version = "1.17.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cfaa3a617d5d222d4b9b41634b1bdede2673a8620d6b0e62fb755ae224ca2ac";
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
