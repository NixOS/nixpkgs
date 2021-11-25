{ lib, buildPythonApplication, fetchPypi, requests, youtube-dl, pytestCheckHook }:

buildPythonApplication rec {
  pname = "gallery_dl";
  version = "1.19.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7fec9ac69582dbd9922666e6ece3142ae52dc9679a2c4a613f6ee94ad09e5f68";
  };

  propagatedBuildInputs = [ requests youtube-dl ];

  checkInputs = [ pytestCheckHook ];
  pytestFlagsArray = [
    # requires network access
    "--ignore=test/test_results.py"
    "--ignore=test/test_downloader.py"
  ];

  meta = with lib; {
    description = "Command-line program to download image-galleries and -collections from several image hosting sites";
    homepage = "https://github.com/mikf/gallery-dl";
    changelog = "https://github.com/mikf/gallery-dl/raw/v${version}/CHANGELOG.md";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dawidsowa marsam ];
  };
}
