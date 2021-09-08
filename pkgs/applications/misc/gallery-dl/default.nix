{ lib, buildPythonApplication, fetchPypi, requests, pytestCheckHook }:

buildPythonApplication rec {
  pname = "gallery_dl";
  version = "1.18.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bdb84706fdde867fe2ee11c74c8c51af4e560399bd5fa562f19bfcaf8fc0dac9";
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
    changelog = "https://github.com/mikf/gallery-dl/raw/v${version}/CHANGELOG.md";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dawidsowa marsam ];
  };
}
