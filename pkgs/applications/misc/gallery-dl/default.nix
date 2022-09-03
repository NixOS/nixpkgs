{ lib, buildPythonApplication, fetchPypi, requests, yt-dlp, pytestCheckHook }:

buildPythonApplication rec {
  pname = "gallery_dl";
  version = "1.23.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-cGLtz5UPTIp0WfChKWdnrD4C+mGv+d83eHRrzpD7MIs=";
  };

  propagatedBuildInputs = [ requests yt-dlp ];

  checkInputs = [ pytestCheckHook ];

  pytestFlagsArray = [
    # requires network access
    "--ignore=test/test_results.py"
    "--ignore=test/test_downloader.py"

    # incompatible with pytestCheckHook
    "--ignore=test/test_ytdl.py"
  ];

  meta = with lib; {
    description = "Command-line program to download image-galleries and -collections from several image hosting sites";
    homepage = "https://github.com/mikf/gallery-dl";
    changelog = "https://github.com/mikf/gallery-dl/raw/v${version}/CHANGELOG.md";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dawidsowa marsam ];
  };
}
