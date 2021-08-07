{ lib, buildPythonApplication, fetchPypi, requests, pytestCheckHook }:

buildPythonApplication rec {
  pname = "gallery_dl";
  version = "1.18.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "786772ce774929ef1ba64d8394dbab329a72447fd8b930968bc1fb0aacdba567";
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
