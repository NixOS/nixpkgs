{ lib, buildPythonApplication, fetchPypi, requests, yt-dlp, pytestCheckHook }:

buildPythonApplication rec {
  pname = "gallery_dl";
  version = "1.20.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6d1d97bd08a2a0dcfb0578e759fb83c4902b395405b3e3238673f684973b0556";
  };

  propagatedBuildInputs = [ requests yt-dlp ];

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
