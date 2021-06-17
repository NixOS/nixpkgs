{ lib, buildPythonApplication, fetchPypi, requests, pytestCheckHook }:

buildPythonApplication rec {
  pname = "gallery_dl";
  version = "1.17.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9d64bca2bf0cdecaff1336e0656917eb9028586fee4ac342761d6cb9a0cdb4f9";
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
